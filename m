Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab0LHICB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 03:02:01 -0500
Received: from web31809.mail.mud.yahoo.com ([68.142.207.72]:34530 "HELO
	web31809.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753507Ab0LHIB7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 03:01:59 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=5AbpcGBoXPO4f1Ch5shg0k52bdjyxV6J9PTtxcPz13eqVQovWjTUR+1ObewNYmThcqxMbY0h04sUmRr4hLZBouhAxeNFeaeDIZI0glM6aZHA8/zVNiR/XkSTX0Jsw+HXezmn2hdADcwqmhhMR/tCSd7SRP773YER2lty+phEDcM=;
Message-ID: <859462.89140.qm@web31809.mail.mud.yahoo.com>
X-YMail-OSG: YYqgVp4VM1mzF7wndj5vlknN6YJCjR8oNvaFGVL9atFOcWT
 9NoWK.0ChF1BRDe_ZGPbVHJyO09Dmfr85hqoHTPWYgAsJEkpgILNCu6V6w5O
 VK5lAdYfMGcUtDlH2rmme9LrJaOB0gUrLI6AGWQSiR14gtnMO7UIz_HE0Jw1
 mYo3zfW22fds5nxEOVtWLzMSBU6RY2_Difebw0v8yIHEXD0DZXiRoSP9KVTD
 8CelMQzcwNV_hbgHsVr5J1zV2BGYd7yNPh9jnBiWF1j0yB9gGvwnk3SCVujb
 ntv6hp4rTVK8B53tbq1xyi5J5xYejq_hKhH1hkW_lLfJkZHjGoiWK_C4Sg5O
 xlM.kdtNnnB2x4M3vTFeA2steX36ed60hvD8MPBiTv6Fugw--
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.289296
Date: Wed, 8 Dec 2010 00:01:57 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH repost 3] [SCSI] Retrieve the Caching mode page
To: Greg KH <greg@kroah.com>, James Bottomley <James.Bottomley@suse.de>
Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-usb@vger.kernel.org
In-Reply-To: <1291784742.24312.40.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Tue, 12/7/10, James Bottomley <James.Bottomley@suse.de> wrote:
> Greg KH wrote:
> > On Tue, Dec 07, 2010 at 04:02:26PM -0800, Luben Tuikov
> wrote:
> > > --- On Sun, 12/5/10, Luben Tuikov <ltuikov@yahoo.com>
> wrote:
> > > > --- On Wed, 11/24/10, Luben Tuikov
> > > > <ltuikov@yahoo.com>
> > > > wrote:
> > > > > 
> > > > > CBI/BBB isn't supposed to be, nor is
> designed to
> > > > support
> > > > > SAM-modern devices. So while REQUEST
> LUN /may/ work on
> > > > some
> > > > > devices which implement it in their
> firmware, it is
> > > > NOT a
> > > > > requirement for those devices as they
> are not required
> > > > to
> > > > > adhere to any SAM version. Those
> transport protocols
> > > > define
> > > > > a class-specific request to get the
> maximum LUN, and
> > > > another
> > > > > to reset the target port (instead of
> I_T Reset or LU
> > > > Reset).
> > > > > They also do not support SCSI Status
> completion of
> > > > the
> > > > > command, nor Autosense. They also do
> not provide TMFs.
> > > > They
> > > > > provide none of the SCSI transport
> protocol services
> > > > in
> > > > > support of the Execute Command
> procedure call. The
> > > > SCSI
> > > > > layer shouldn't be trying to guess
> their "SCSI
> > > > version", and
> > > > > or treat them as real SCSI devices
> sending REPORT
> > > > LUNs, etc.
> > > > > commands.
> > > > > 
> > > > > Newer, modern transport protocols over
> USB, are part
> > > > of
> > > > > SAM, and it is devices who connect via
> those protocols
> > > > that
> > > > > are being disadvantaged, due to the
> adoption
> > > > (assumption) of
> > > > > CBI/BBB well into the SCSI layer.
> > > > > 
> > > > > To this effect, the transport protocol
> can tell upper
> > > > > layers if the device is true SCSI (new
> usb transports
> > > > or
> > > > > other) or hybrid (usb-storage). In the
> former case,
> > > > the
> > > > > device is a SCSI device, in the latter,
> only basic
> > > > commands
> > > > > should be attempted.
> > > > > 
> > > > > This isn't to say that firmware for
> those devices
> > > > wouldn't
> > > > > be buggy. Of course it will, and most
> will probably
> > > > port
> > > > > their legacy FW over to the new SPTL,
> but the
> > > > protocol
> > > > > requirements are there by design (i.e.
> there is no
> > > > longer
> > > > > Get Max Lun class-specific request, the
> application
> > > > client
> > > > > has to send REPORT LUNS, and FW has to
> answer it) and
> > > > we
> > > > > have to accommodate that.
> > > > > 
> > > > > It is in this spirit that this patch
> doesn't change
> > > > wire
> > > > > behavior, but simply parses data
> returned by a
> > > > command
> > > > > already supported by older protocols.
> > > > 
> > > > Did anyone pick up this patch?
> > > 
> > > It's been over 6 weeks now that this patch's been
> in these mailing lists.
> > > Will anyone pick up this patch, or should I stop
> posting it every
> > > week? Please let me know--it's been posted here 6
> times in the last 6
> > > weeks.
> > 
> > James, this is all you.  Any thoughts?
> 
> Well, not other than I've already said:  I think it
> looks OK, so I
> marked it for my merge window queue.  I'd still rather
> like USB people
> to confirm that the original reason why this was done (to
> prevent device
> crashes on the mode sense) is no longer an issue ... but
> it's only USB
> stuff, so suppose I'm OK with finding out in the field.

Check their responses above in this thread. The USB people seem to be okay with it. The thread is archived here: http://marc.info/?t=129044508400003&r=1&w=2.

   Luben

