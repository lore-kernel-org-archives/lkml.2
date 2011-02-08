Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab1BHKAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 05:00:50 -0500
Received: from mail.skyhub.de ([78.46.96.112]:46461 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966Ab1BHKAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 05:00:49 -0500
Date: Tue, 8 Feb 2011 11:00:39 +0100
From: Borislav Petkov <bp@alien8.de>
To: dave b <db.pub.mail@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, borislav.petkov@amd.com
Subject: Re: I do not know if this is the correct place to ask about this
 but...
Message-ID: <20110208100039.GA7020@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	dave b <db.pub.mail@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	borislav.petkov@amd.com
References: <AANLkTi=1wjdu3kT6nimU0fnZStG01a57D3O5Up+oJRdr@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTi=1wjdu3kT6nimU0fnZStG01a57D3O5Up+oJRdr@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 08:31:50PM +1100, dave b wrote:
> I do not know if this is the correct place to ask about this but...
> I have only seen the following output output twice and both times have
> been when I was running a 2.6.37 kernel.
> 
> [152399.816058] [Hardware Error]: MC4_STATUS: Corrected error, other
> errors lost: no, CPU context corrupt: no, CECC Error
> [152399.816075] [Hardware Error]: Northbridge Error, node 0: , core:
> 1L3 ECC data cache error.
> [152399.816086] [Hardware Error]: Transaction: RD, Type: GEN, Cache
> Level: L3/GEN
> [152399.816092] Disabling lock debugging due to kernel taint
> [152399.816099] [Hardware Error]: Machine check events logged
> 
> I assume it is just a coincidence. Also, I am not exactly sure what
> the message "means". (Yes I can read the text - but I haven't found
> good documentation which describes the impact it). Note: I submitted a
> bug[0] regarding 'the output' the first time this occurrence.

This is a L3 cache correctable error on an AMD F10h machine I'd guess.

You could go and install x86info from
http://codemonkey.org.uk/projects/x86info/ and do as root

for i in $(seq 0 3); do echo -e "\nCPU$i:"; lsmsr -c $i -a; done > lsmsr.log

 [ ($seq 0 3) assumes you have 4 cores, adjust it according to your
    machine. Also, you need msr.ko module support, i.e. CONFIG_X86_MSR in
    your kernel .config. ]

and send me the lsmsr.log file to check whether there is some more info
about the L3 error.

If you don't have the msr.ko support (or CONFIG_X86_MSR is not set
to y in your config) that tool won't help. In that case, I'd suggest
you upgrade your kernel to 2.6.38-rc4 which is stable enough, enable
CONFIG_X86_MSR and catch the error again. Then retry the small bash
oneliner above again.

That should be all for now, feel free to ask questions should anything
be not clear.

Thanks.

-- 
Regards/Gruss,
    Boris.
