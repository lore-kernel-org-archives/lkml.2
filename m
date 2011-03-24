Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934026Ab1CXUKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:10:07 -0400
Received: from adelie.canonical.com ([91.189.90.139]:34632 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757093Ab1CXUKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:10:03 -0400
Date: Thu, 24 Mar 2011 15:09:58 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Chris Bagwell <chris@cnpbagwell.com>, Matthew Garrett <mjg@redhat.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] eeepc-wmi: Add support for T101MT Home/Express Gate
 key
Message-ID: <20110324200958.GC31713@thinkpad-t410>
Mail-Followup-To: Corentin Chary <corentin.chary@gmail.com>,
	Chris Bagwell <chris@cnpbagwell.com>,
	Matthew Garrett <mjg@redhat.com>,
	acpi4asus-user@lists.sourceforge.net,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20110324195720.GB31713@thinkpad-t410>
 <1300997035-14104-2-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300997035-14104-2-git-send-email-seth.forshee@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 03:03:55PM -0500, Seth Forshee wrote:
> @@ -79,6 +94,52 @@ static const struct key_entry eeepc_wmi_keymap[] = {
>  	{ KE_END, 0},
>  };
>  
> +static void eeepc_wmi_key_filter(struct asus_wmi_driver *asus_wmi, int *code,
> +				 int *value, int *autorelease)
> +{
> +	struct eeepc_wmi_driver *eeepc = to_eeepc_wmi_driver(asus_wmi);
> +	int is_press;
> +
> +	/*
> +	 * The following behavior is used for T101MT "Home" key:
> +	 * 
> +	 *   On press:   No event set
> +	 *   On hold:    KEY_PROG2 press sent once w/o autorelease
> +	 *   On release: If key was held, KEY_PROG2 release sent.
> +	 *               Otherwise KEY_HOME press sent w/ autorelease.

Doh, just noticed that this comment is incorrect. I'll fix it, but I'll
wait for comments before sending new patches.

