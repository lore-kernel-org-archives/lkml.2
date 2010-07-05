Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab0GEXvF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 19:51:05 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54293 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360Ab0GEXvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 19:51:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=gWJ2BzSy2sx4oPw9OfoaGAAkyciwleZmRBrdf5ArUxEUxvI55SjDBbO0FCVhK+phGX
         kuqz/bC7r3pJneLfKCRTIJwbk3Z8mmGqnZM2J7LUu1fk+2d6Yxs+WmKO5GFqaH3iDotU
         ZLLCDXmP6nAv+ijVh7GeMPlrl3cy3Knxie/HM=
Message-ID: <4C326FE1.2020005@gmail.com>
Date: Mon, 05 Jul 2010 17:50:57 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100624 Fedora/3.1-1.fc13 Thunderbird/3.1
MIME-Version: 1.0
To: =?UTF-8?B?VMO2csO2ayBFZHdpbg==?= <edwintorok@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: ata: failed to IDENTIFY / SRST failed (errno = -16) problems
 on/after booting 2.6.35-rc3
References: <20100627232347.2f1dc4fd@debian> <20100705224627.3a158e8c@debian>
In-Reply-To: <20100705224627.3a158e8c@debian>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2010 01:46 PM, Török Edwin wrote:
> On Sun, 27 Jun 2010 23:23:47 +0300
> Török Edwin<edwintorok@gmail.com>  wrote:
>
>> Hi,
>>
>> Using 2.6.35-rc3 I noticed this in my dmesg (see end of email for full dmesg output)
>> [28144.351747] ata9: drained 65536 bytes to clear DRQ.
>> [28144.460834] ata9.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
>> [28144.460838] sr 8:0:1:0: CDB: Prevent/Allow Medium Removal: 1e 00 00
>> 00 00 00 [28144.460846] ata9.01: cmd
>> a0/00:00:00:00:00/00:00:00:00:00/b0 tag 0 [28144.460846]          res
>> 7f/7f:7f:7f:7f:7f/00:00:00:00:00/7f Emask 0x3 (HSM violation)
>> [28144.460849] ata9.01: status: { DRDY DF DRQ ERR } [28144.460867]
>> ata9: soft resetting link
>> ....
>> [32977.433092] ata9: EH complete
>
> The problem has just become worse:
>   - an error occurs on ata9 during boot, taking several minutes to bring
>     up the link:
>
> Jul  5 09:41:49 debian kernel: [   15.824148] ata9.01: qc timeout (cmd
> 0xa1)
> Jul  5 09:41:49 debian kernel: [   15.824155] ata9.01: failed to
> IDENTIFY (I/O error, err_mask=0x4)
> Jul  5 09:41:49 debian kernel: [   20.864007] ata9: link is slow to
> respond, please be patient (ready=0)
> Jul  5 09:41:49 debian kernel: [   25.848007] ata9: device not ready
> (errno=-16), forcing hardreset
> Jul  5 09:41:49 debian kernel: [   31.044007] ata9: link is slow to
> respond, please be patient (ready=0)
> Jul  5 09:41:49 debian kernel: [   41.056006] ata9: link is slow to
> respond, please be patient (ready=0)
> Jul  5 09:41:49 debian kernel: [   51.068007] ata9: link is slow to
> respond, please be patient (ready=0)
> Jul  5 09:41:49 debian kernel: [   74.492148] ata9.00: qc timeout (cmd
> 0xa1)
> Jul  5 09:41:49 debian kernel: [   74.492154] ata9.00: failed to
> IDENTIFY (I/O error, err_mask=0x4)
> Jul  5 09:41:49 debian kernel: [   79.532006] ata9: link is slow to
> respond, please be patient (ready=0)
> Jul  5 09:41:49 debian kernel: [   84.516007] ata9: device not ready
> (errno=-16), forcing hardreset
> Jul  5 09:41:49 debian kernel: [   89.712006] ata9: link is slow to
> respond, please be patient (ready=0)
> Jul  5 09:41:49 debian kernel: [   99.724007] ata9: link is slow to
> respond, please be patient (ready=0)
> Jul  5 09:41:49 debian kernel: [  109.736007] ata9: link is slow to
> respond, please be patient (ready=0)
> Jul  5 09:41:49 debian kernel: [  138.184642] ata9.00: ATAPI: ASUS
> CRW-5232AS, 1.01, max UDMA/33
> Jul  5 09:41:49 debian kernel: [  138.192670] ata9.00: configured for
> UDMA/33
>
>     - sometimes the link never comes up (well never is ~5m, I
> didn't wait longer). it just keeps trying to reset the link saying
> that SRST failed with errno -16 ... endlessly, hence booting is
> impossible.
>
> This is bad: the CDROM is not required to successfully boot (in this
> case anyway), the kernel should IMHO just try reestablishing that link
> in a background thread and finish booting normally.

I think it would if pata_jmicron had parallel scanning enabled, which it 
currently doesn't. It may be able to be turned on, someone just has to 
make sure it's safe for that chipset.

>
> Note that while this DID started to occur soon after I installed
> 2.6.35-rc3 (like 1 bisection run + 5 more boots later), if I now try to
> boot 2.6.34 the same thing happens (i.e. link resets endlessly on boot).
> This has NEVER happened with a kernel<2.6.35-rc3 though .. until
> now.
>
> Also I noticed that the BIOS sometimes hanged during boot (probably
> trying to establish a link to the CDROM too), resetting it a couple of
> times allowed it to reach Linux, but then Linux hanged.
> It could be a hardware failure of the CDROM that just happened to occur
> after I installed 2.6.35-rc3, I don't know.

It does sound like a hardware problem, yes, from those symptoms.

>
> For now I pulled out the power+data cables from my 2 CDROMs so I can at
> least boot. That of course made all these problems go away.
>
> When I have some more time I'll try plugging back the 2 CDROMs one at a
> time, exchange the cables, etc. to see if it is a problem with one of
> the CDROM drives themselves.
>
> In the meantime are there any debug messages I can enable for the next
> time I try booting with the CDROMs?
> Is there any diagnostic I can run from Linux to tell where the problem
> is:
>   - the JMicron PATA controller?
>   - the cables?
>   - the CDROM drive(s) themselves?

It's probably going to be difficult to isolate that problem from 
software, it's likely easiest to remove or swap components until the 
problem goes away.
