Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab0LHAJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:09:10 -0500
Received: from web31816.mail.mud.yahoo.com ([68.142.206.169]:22234 "HELO
	web31816.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752659Ab0LHAJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:09:08 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Dec 2010 19:09:08 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type;
  b=Zy924bNK+bAFkFim1iWbwIfciaiMZfPihSsuojZG8KA7iQMmr6Xm656dsjdQQSpUivh66xiHrUD6mZD4GpGuxJMReyjZTabJhDOuXi43wtnfQPw3wkslUPpbFF84/v7yDWnHkN0w32ss/spk3CUFxmKwiLYcp36BaRd0Nt1g1Ao=;
Message-ID: <732182.60247.qm@web31816.mail.mud.yahoo.com>
X-YMail-OSG: l_W7O90VM1ngdkBM9uTEvTRxomQgiX29pGi1fa4Hp3X5UuX
 wgv3e5Cc5wZMtfd8ow24cNaOsWzx2yx_mYkUfh460KT4Atni3Hi0x2du8FkI
 zHOuhYOYA2s2ugwqX491giQwM6NvqH27Css7jLbiQ7oKfNpQcUw_tpwGdjSl
 SfWiHmUoOJiRyBVExajutsrnlpI7tpi4OKZSB4Euy4ZHn14PV4rPk0_3Wn12
 cSlFqjhmOG_9kvG.JUDXDWfxf9MrCKo354gi4SWD3LK2x39BWOZ7TF.XggdX
 1xFoi7FsXN4gCdZ8Qll2OwOt2DpoghrWoiftPN8G2K.TD8chn5rKWTQHajc5
 p7BB2F4oHWOMlecHxow--
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.289296
Date: Tue, 7 Dec 2010 16:02:26 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH repost 3] [SCSI] Retrieve the Caching mode page
To: James Bottomley <James.Bottomley@suse.de>
Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Sun, 12/5/10, Luben Tuikov <ltuikov@yahoo.com> wrote:
> --- On Wed, 11/24/10, Luben Tuikov
> <ltuikov@yahoo.com>
> wrote:
> > 
> > CBI/BBB isn't supposed to be, nor is designed to
> support
> > SAM-modern devices. So while REQUEST LUN /may/ work on
> some
> > devices which implement it in their firmware, it is
> NOT a
> > requirement for those devices as they are not required
> to
> > adhere to any SAM version. Those transport protocols
> define
> > a class-specific request to get the maximum LUN, and
> another
> > to reset the target port (instead of I_T Reset or LU
> Reset).
> > They also do not support SCSI Status completion of
> the
> > command, nor Autosense. They also do not provide TMFs.
> They
> > provide none of the SCSI transport protocol services
> in
> > support of the Execute Command procedure call. The
> SCSI
> > layer shouldn't be trying to guess their "SCSI
> version", and
> > or treat them as real SCSI devices sending REPORT
> LUNs, etc.
> > commands.
> > 
> > Newer, modern transport protocols over USB, are part
> of
> > SAM, and it is devices who connect via those protocols
> that
> > are being disadvantaged, due to the adoption
> (assumption) of
> > CBI/BBB well into the SCSI layer.
> > 
> > To this effect, the transport protocol can tell upper
> > layers if the device is true SCSI (new usb transports
> or
> > other) or hybrid (usb-storage). In the former case,
> the
> > device is a SCSI device, in the latter, only basic
> commands
> > should be attempted.
> > 
> > This isn't to say that firmware for those devices
> wouldn't
> > be buggy. Of course it will, and most will probably
> port
> > their legacy FW over to the new SPTL, but the
> protocol
> > requirements are there by design (i.e. there is no
> longer
> > Get Max Lun class-specific request, the application
> client
> > has to send REPORT LUNS, and FW has to answer it) and
> we
> > have to accommodate that.
> > 
> > It is in this spirit that this patch doesn't change
> wire
> > behavior, but simply parses data returned by a
> command
> > already supported by older protocols.
> 
> Did anyone pick up this patch?

It's been over 6 weeks now that this patch's been in these mailing lists.
Will anyone pick up this patch, or should I stop posting it every week? Please let me know--it's been posted here 6 times in the last 6 weeks.

Thanks,
   Luben

