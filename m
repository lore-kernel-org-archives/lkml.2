Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab0LEUxx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 15:53:53 -0500
Received: from web31807.mail.mud.yahoo.com ([68.142.207.70]:37793 "HELO
	web31807.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753896Ab0LEUxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 15:53:51 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type;
  b=sObzqSM/QMrJLd5BvCFlqTFH8R2c34WOwpGFxTaRHyI7xAuKJr6CGi9JG1KySG33jXdw+spHcgWONpkdXvKCADLILi63A6/HFwnZpaZyo2De/C/OV/eBDAXCpaIEimPDvpAaW7oboOGiTYPl/LOg372yHYu5+0BEwr1280TuY8E=;
Message-ID: <874800.41815.qm@web31807.mail.mud.yahoo.com>
X-YMail-OSG: qzOuMBIVM1kj7G8Ej.PAu6tpsyB7OWsyuoGAbn2edoOFR9_
 GgF2mhLv4ZAYYyMvJMvhvOQykNybpYhLtIZjAHrLTUF7d5g3OaOPIeJLmpgD
 CH1bBDDgTK0UoX8ehLE_z0XCt91cHXBEygz8IHpqIzvPRCsPfZ_fd08wkhK4
 bXXRZ63DP_M8_364i5Pg4YXMEy0R3LCZzLpQiGfN0lmzlW0r9KonemjBUPPj
 rpgSaCsVNxLwThgntcbAfPvNmCsL2zf9YwJnp9Uv16Q35tBoGaA3aCM.ZNXw
 Oci333mhC__Nef7Pb1BPeXDgfmNodpQixyCuy_bhHHmIyMV.YtPLrgxs9XXj
 mKtrHwPI.VI4QA_mxZw90r4djDK.7H98ZsmN.2vzSvWl6Vw--
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.289296
Date: Sun, 5 Dec 2010 12:53:50 -0800 (PST)
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

--- On Wed, 11/24/10, Luben Tuikov <ltuikov@yahoo.com> wrote:
> 
> CBI/BBB isn't supposed to be, nor is designed to support
> SAM-modern devices. So while REQUEST LUN /may/ work on some
> devices which implement it in their firmware, it is NOT a
> requirement for those devices as they are not required to
> adhere to any SAM version. Those transport protocols define
> a class-specific request to get the maximum LUN, and another
> to reset the target port (instead of I_T Reset or LU Reset).
> They also do not support SCSI Status completion of the
> command, nor Autosense. They also do not provide TMFs. They
> provide none of the SCSI transport protocol services in
> support of the Execute Command procedure call. The SCSI
> layer shouldn't be trying to guess their "SCSI version", and
> or treat them as real SCSI devices sending REPORT LUNs, etc.
> commands.
> 
> Newer, modern transport protocols over USB, are part of
> SAM, and it is devices who connect via those protocols that
> are being disadvantaged, due to the adoption (assumption) of
> CBI/BBB well into the SCSI layer.
> 
> To this effect, the transport protocol can tell upper
> layers if the device is true SCSI (new usb transports or
> other) or hybrid (usb-storage). In the former case, the
> device is a SCSI device, in the latter, only basic commands
> should be attempted.
> 
> This isn't to say that firmware for those devices wouldn't
> be buggy. Of course it will, and most will probably port
> their legacy FW over to the new SPTL, but the protocol
> requirements are there by design (i.e. there is no longer
> Get Max Lun class-specific request, the application client
> has to send REPORT LUNS, and FW has to answer it) and we
> have to accommodate that.
> 
> It is in this spirit that this patch doesn't change wire
> behavior, but simply parses data returned by a command
> already supported by older protocols.

Did anyone pick up this patch?

    Luben

