Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab1EMVqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 17:46:14 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60610 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756995Ab1EMVqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 17:46:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=F8AHCPXW6nk8odO0hQ1T0kMm/47TCUWfnNQflIGIOZtE3CnJrwEyN9kSZ+gfPEEATu
         nJQ88nvEdAhuYMqPK3d38uOe/3AkMLdc2L+WLqQgip1czfeuT/+le52xS0IB7+aMNXsi
         o2GzVr3emMoblQFWBnVlmgdsvFlT0fbKxbcGM=
Message-ID: <4DCDA6A2.4060001@garzik.org>
Date: Fri, 13 May 2011 17:46:10 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dan Williams <dan.j.williams@intel.com>,
        James.Bottomley@hansenpartnership.com, Christoph Hellwig <hch@lst.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Dave Jiang <dave.jiang@intel.com>, David Milburn <dmilburn@redhat.com>,
        Ed Ciechanowski <ed.ciechanowski@intel.com>,
        Ed Nadolski <edmund.nadolski@intel.com>,
        Jacek Danecki <jacek.danecki@intel.com>,
        Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Subject: Re: [GIT PULL] isci merge candidate
References: <1305317680.21099.83.camel@dwillia2-linux> <BANLkTim3igaB8XXQkDY6GEutWfbK-o840A@mail.gmail.com>
In-Reply-To: <BANLkTim3igaB8XXQkDY6GEutWfbK-o840A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2011 04:34 PM, Linus Torvalds wrote:
> What's the likely user base of this?

Pretty big, I imagine.

> Why is it a SCSI driver rather
> than SATA?

It's "server" SAS hardware, a la mvsas driver.  SAS hardware is that 
"lovely" superset of SATA + SCSI, where SATA is one of several frame 
formats the device may speak.  So it is definitely a SCSI driver, that 
hooks into SATA processing via ata_sas_* hooks and functions.

> Why is it so f&*%ing big?

1. Because it's a SAS driver :)

2. Because it used to be an ugly vendor driver, now in the process of 
being cleaned up, rather than a nice, clean from-scratch Linux driver.

So it's a bit of a tough call.  It still needs more hammering and 
cleaning, but if this is what winds up on all Intel "server" boards that 
makes it pretty important.

	Jeff


