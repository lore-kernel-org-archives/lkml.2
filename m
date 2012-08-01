Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab2HAJRw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 05:17:52 -0400
Received: from smtp-out-180.synserver.de ([212.40.185.180]:1073 "EHLO
	smtp-out-178.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753388Ab2HAJRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 05:17:50 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 17919
Message-ID: <5018F537.209@metafoo.de>
Date: Wed, 01 Aug 2012 11:21:59 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: awful kconfig help texts.
References: <20120731151600.GA19412@redhat.com> <20120731170741.GA4735@x1.osrc.amd.com> <20120731172638.GE16873@home.goodmis.org> <20120731174249.GB4735@x1.osrc.amd.com> <20120801074742.GH29673@avionic-0098.adnet.avionic-design.de> <20120801085644.GA21303@liondog.tnic>
In-Reply-To: <20120801085644.GA21303@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2012 10:56 AM, Borislav Petkov wrote:
> On Wed, Aug 01, 2012 at 09:47:42AM +0200, Thierry Reding wrote:
>> On Tue, Jul 31, 2012 at 07:42:49PM +0200, Borislav Petkov wrote:
>>> On Tue, Jul 31, 2012 at 01:26:38PM -0400, Steven Rostedt wrote:
>>>> Then shouldn't this not have a prompt and just be selected by those
>>>> PWM drivers below?
>>>
>>> It gives an empty menu due to the deps of the single PWM drivers.
>>>
>>> But the whole CONFIG_PWM thing should simply depend on !X86 so that it
>>> doesn't appear in drivers/.
>>
>> I don't think that's a good idea. That would mean I would have to add
>> !SPARC and !S390 and many other to that list as well. Also there are a
>> couple of drivers that are in the process of being ported which are not
>> restricted to ARM or embedded in general. So even if we make this !X86
>> now, eventually it will pop up again.
> 
> Hmm, how about having a synthetic define CONFIG_ARCH_PWM and each arch
> which has such a driver can select it and then CONFIG_PWM would depend
> on that. Would that even work?
> 

One major reason for the new PWM framework is to be able to support arch
independent PWM drivers, like those for companion chips with PWM
capabilities. Restricting the config option to certain architectures
wouldn't work.

- Lars
