Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab2DKLfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 07:35:30 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:39087 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab2DKLf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 07:35:26 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Kay Sievers <kay@vrfy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartmann <greg@kroah.com>
References: <1333569554.864.3.camel@mop>
	<CA+55aFyMO=xx0xNvggR-1fs-jKi_zaayNfgCa3HCNkvH0yA16g@mail.gmail.com>
	<1333655231.725.27.camel@mop>
Date: Wed, 11 Apr 2012 04:39:16 -0700
In-Reply-To: <1333655231.725.27.camel@mop> (Kay Sievers's message of "Thu, 05
	Apr 2012 21:47:11 +0200")
Message-ID: <m1k41mebvf.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+k0063ys0CQ18tUJwH20WARTzHzcbrLP8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0123]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 XM_Sft_Co_L33T XM_Sft_Co_L33T
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Kay Sievers <kay@vrfy.org>
X-Spam-Relay-Country: **
Subject: Re: [PATCH] printk: support structured and multi-facility log messages
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers <kay@vrfy.org> writes:

> On Thu, 2012-04-05 at 10:09 -0700, Linus Torvalds wrote:
>> On Wed, Apr 4, 2012 at 12:59 PM, Kay Sievers <kay@vrfy.org> wrote:
>> > From: Kay Sievers <kay@vrfy.org>
>> > Subject: printk: support structured and multi-facility log messages
>
>> Other than this issue, I actually don't have any problems with the
>> code. Most of it seems fairly reasonable. But this one just made me go
>> "wtf, how can something so reasonable then be so completely crazy in
>> this regard".
>
> Binary support is just what we are required to support in userspace
> logging. We can surely live without that in the kernel.
>
> What we are looking for is mainly the 'context' of the message, and not
> possible binary data; and that will still be provided the same way with
> the now simpler and more line-based output.
>
> Better?
>
>   [root@mop ~]# cat /dev/kmsg
>   5,0,0;Linux version 3.4.0-rc1+ (kay@mop) (gcc version 4.7.0 20120315 ...
>   6,1,0;Command line: root=/dev/sda1 console=tty0 console=ttyS0
>   6,2,0;BIOS-provided physical RAM map:
>   6,3,0; BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
>   6,4,0; BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
>   6,5,0; BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
>   6,6,0; BIOS-e820: 0000000000100000 - 000000001fffd000 (usable)
>   6 ,7,0; BIOS-e820: 000000001fffd000 - 0000000020000000 (reserved)
>   6,8,0; BIOS-e820: 00000000feffc000 - 00000000ff000000 (reserved)
>   6,9,0; BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
>   6,10,0;NX (Execute Disable) protection: active
>   6,11,0;DMI 2.4 present.
>   [...]
>   4,382,6189353;sr0: scsi3-mmc drive: 4x/4x cd/rw xa/form2 tray
>   6,383,6190667;cdrom: Uniform CD-ROM driver Revision: 3.20
>   7,384,6193747;sr 1:0:0:0: Attached scsi CD-ROM sr0
>    SUBSYSTEM=scsi
>    DEVICE=+scsi:1:0:0:0

These aren't shell variables we are creating so why put the keys in
uppercase?  All that shouting hurts my eyes.

>   6,385,9202973;EXT4-fs (sda1): re-mounted. Opts: (null)
>   6,386,10929285;Bluetooth: Core ver 2.16
>   6,387,10930852;NET: Registered protocol family 31
>   6,388,10932686;Bluetooth: HCI device and connection manager initialized
>   6,389,10935723;Bluetooth: HCI socket layer initialized
>   6,390,10937847;Bluetooth: L2CAP socket layer initialized
>   ...

So I look at this output I look at how much more bloated my screen feels
as single lines turn into multiple lines and I ask.  Is there any reason
for not encoding structured syslog data the way structured data is
encoded in the syslog rfc RFC5424?  Especially as recently my screens
like to get shorter and wider.

Aka preceding the message with a string like:
[dev subsys="name" dev="major:minor]

aka
[dev subsys="scsi" dev_name="1:0:0:0"] sr 1:0:0:0: Attached scsi CD-ROM sr0

I can see arguments for going different ways but having multiple
sections for different kinds of values seems like a life saver for
long term maintenance.

Wrapping key/value pairs in [] seems compatible with what we are doing
with timestamps already.  So it feels more evolutionary.

Making the printk buffer record oriented might be totally reasonable,
however I have to point out that you can move to RFC5424 style
structured output in printks like dev_printk without changes to
printk at all.

Maybe I am wrong.  Maybe this is all good cleanup.  But it certainly
looks like doing everything the hard way.

>  #ifdef CONFIG_KEXEC
>  /*
> @@ -165,9 +622,9 @@ static int saved_console_loglevel = -1;
>  void log_buf_kexec_setup(void)
>  {
>  	VMCOREINFO_SYMBOL(log_buf);
> -	VMCOREINFO_SYMBOL(log_end);
>  	VMCOREINFO_SYMBOL(log_buf_len);
> -	VMCOREINFO_SYMBOL(logged_chars);
> +	VMCOREINFO_SYMBOL(log_first_idx);
> +	VMCOREINFO_SYMBOL(log_next_idx);
>  }
>  #endif

Is their an accompanying patch to update everyone's crash dump analysis
tools to extract the new format of the syslog ring buffer?

Eric

