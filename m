Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab2HTTRc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 15:17:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65438 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab2HTTR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 15:17:28 -0400
MIME-Version: 1.0
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D413805C31@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D413805C31@USINDEM103.corp.hds.com>
From: Mike Waychison <mikew@google.com>
Date: Mon, 20 Aug 2012 12:17:07 -0700
Message-ID: <CAGTjWtAeL4AMWhWeiCrtXjumNSCjT1KTXd0KnH3_-4g_L91=Dw@mail.gmail.com>
Subject: Re: [RFC][PATCH v2 1/3] efivars: Disable external interrupt while
 holding efivars->lock
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Mike Waychison <mikew@google.com>

> @@ -1101,11 +1107,12 @@ out_free:
>  void unregister_efivars(struct efivars *efivars)
>  {
>         struct efivar_entry *entry, *n;
> +       unsigned long flags;
>
>         list_for_each_entry_safe(entry, n, &efivars->list, list) {
> -               spin_lock(&efivars->lock);
> +               spin_lock_irqsave(&efivars->lock, flags);
>                 list_del(&entry->list);
> -               spin_unlock(&efivars->lock);
> +               spin_unlock_irqrestore(&efivars->lock, flags);
>                 efivar_unregister(entry);
>         }
>         if (efivars->new_var)

Feel free to remove any other uses of flags where you know that you
are being called from process context.
