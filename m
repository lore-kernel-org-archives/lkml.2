Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab1BHOxL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 09:53:11 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:33572 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab1BHOxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 09:53:07 -0500
Date: Tue, 8 Feb 2011 14:53:01 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: platform-driver-x86@vger.kernel.org,
        linux acpi <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: What's part of the ABI (breaking eeepc-wmi)
Message-ID: <20110208145301.GA12930@srcf.ucam.org>
References: <AANLkTim5kG-pZRpj+6ckOvuk5ZSJ_O7zbwBnC4JNQPtS@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim5kG-pZRpj+6ckOvuk5ZSJ_O7zbwBnC4JNQPtS@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 08:51:27AM +0000, Corentin Chary wrote:

> A first solution is to rename eeepc-wmi asus-wmi, and create an alias
> to make eeepc-wmi work. Then this driver would handle asus-wmi and
> eeepc-wmi platform drivers (it could also be splitted in 3
> files/modules, common/notebook/eeepc).
> But then, is it important to keep these strings ?
> - hotplug string ("eeepc-wifi")
> - rfkill names ("eeepc-xxxxx")
> - input strings (.phys and .name)

I think that, realistically, these changes should be fine but may break 
some user code. We don't have a good way of enforcing proper sysfs 
usage.

> - led names ("eeepc::xxxxxx")

But I don't think there's any other way of identifying LEDs, so this 
probably has to stay.

> Any thoughts on that ?

Seems less ugly than the alternatives!

-- 
Matthew Garrett | mjg59@srcf.ucam.org
