Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab0JGS0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 14:26:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39104 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab0JGS0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 14:26:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=a+qPZsJ2lAIWVjJXQN2O/ei/QTlXAOlNbFq845H5fmaDlJkkp8OTa2NRdRvbMQ//tU
         zMiVYdVZq9eHVUz04dG2WD0MwXMIcENe30kJtM/c7DA+qqe127cuMj4qTvk3s208zRUj
         fyHvkmwZRcT0vhk8DGIGx7bIcD2Nqma6diHIU=
Message-ID: <4CAE10C0.9000106@gmail.com>
Date: Thu, 07 Oct 2010 20:26:08 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.9) Gecko/20100914 SUSE/3.1.4 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Savoy, Pavan" <pavan_savoy@ti.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/2] drivers:staging:ti-st: move TI_ST from staging
References: <1286381895-11329-1-git-send-email-pavan_savoy@ti.com> <1286381895-11329-2-git-send-email-pavan_savoy@ti.com> <4CACD234.7020900@gmail.com> <19F8576C6E063C45BE387C64729E739404AA21CEA1@dbde02.ent.ti.com> <4CACF5A7.3010601@gmail.com> <19F8576C6E063C45BE387C64729E739404AA21CEC6@dbde02.ent.ti.com> <4CAD7DAB.8030209@gmail.com> <19F8576C6E063C45BE387C64729E739404AA21D193@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E739404AA21D193@dbde02.ent.ti.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2010 04:52 PM, Savoy, Pavan wrote:
> Per-system? I don't understand this.
> There can be ldisc for each individual TTY, so doesn't that make it per device?

No, you can have only up to NR_LDISCS ldiscs in the system and you have
to choose one of them to "handle" a particular tty.

IOW, you register an ldisc which is available for everybody then. And it
cannot have ->private_data since everybody would share this single
->private_data. Instead everybody comes with their devices as ttys which
have ->private_data for everybody's data and ->disc_data for you to note
anything about the (tty) device.

Am I missing something?

regards,
-- 
js
