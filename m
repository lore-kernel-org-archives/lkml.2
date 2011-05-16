Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab1EPNnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 09:43:16 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:27903 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab1EPNnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 09:43:15 -0400
X-SpamScore: -23
X-BigFish: VPS-23(zzbb2dK1433M9371O1432N98dKzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LLAJFX-02-13U-02
X-M-MSG: 
Message-ID: <4DD128ED.2080502@amd.com>
Date: Mon, 16 May 2011 09:38:53 -0400
From: Boris Ostrovsky <boris.ostrovsky@amd.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: "Rosenfeld, Hans" <Hans.Rosenfeld@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>
Subject: Re: [PATCH] cpu, AMD: Fix another bug in the new errata checking
 code
References: <20110512195938.1728ab52@katamari>	<20110513102154.GB9270@escobedo.osrc.amd.com>	<4DCD2C3F.9070905@amd.com>	<20110513105928.6216ddc8@katamari>	<20110513151921.GA878@escobedo.osrc.amd.com> <20110516084351.003bb214@katamari>
In-Reply-To: <20110516084351.003bb214@katamari>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2011 08:43 AM, Chuck Ebbert wrote:
> On Fri, 13 May 2011 17:19:23 +0200
> Hans Rosenfeld<hans.rosenfeld@amd.com>  wrote:
>>>>> Could you send me the contents of MSRs 0xc0010140, 0xc0010141 and
>>>>> 0xc0010055?
>>>>
>>>> Knowing whether any C state above C1 is declared could be useful too.
>>>>
>>> rdmsr 0xc0010140 gives 2
>>
>> This means that E400 is known ...
>>
>>> rdmsr 0xc0010141 gives 0
>>
>> ... and no workaround is necessary ...
>>
>>> rdmsr 0xc0010055 gives 0
>>
>> ... because C1E is not enabled.
>>
>>> And ARAT is definitely set where it wasn't before these updates.
>>
>> I don't see how that could possibly make a difference if C1E is not even
>> enabled. This is all very strange.
>>
>
> Looking at commit e20a2d205c05cef6b5783df339a7d54adeb50962 ("x86, AMD: Fix
> APIC timer erratum 400 affecting K8 Rev.A-E processors") I see that it
> extended the E400 workaround to cover a whole range of processors that
> have never supported C1E. Isn't this just more of the same problem, only
> happening with processors that support C1E but have it disabled?

Erratum 400 covers not just C1E but also C3 and the latter is not 
covered by OSVW so we may need to update cpu_has_amd_erratum(). 
Fortunately, only a few processors in family 10h support C3. I think, in 
fact, it's only the part that you have (model 6 stepping 2) but we need 
to confirm it. If you know of other FMSs please let us know.

As for expansion of ranges covering this erratum in that commit, it only 
affected family fh.

>
> They are using C3 for idle states, I can confirm that now.

Thanks.

-boris


