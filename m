Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab0GIUyL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 16:54:11 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60608 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960Ab0GIUyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 16:54:09 -0400
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Subject: Re: [PATCH] acer-wmi: fix memory leaks in wmab_execute error path
Date: Fri, 9 Jul 2010 21:53:55 +0100
User-Agent: KMail/1.13.3 (Linux/2.6.33.1cc; KDE/4.4.3; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg@redhat.com>, Thomas Renninger <trenn@suse.de>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       platform-driver-x86@vger.kernel.org
References: <1278647475.26099.2.camel@mola>
In-Reply-To: <1278647475.26099.2.camel@mola>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201007092153.55715.carlos@strangeworlds.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 July 2010 04:51:15 Axel Lin wrote:
> When acpi_evaluate_object() is passed ACPI_ALLOCATE_BUFFER,
> the caller must kfree the returned buffer if AE_OK is returned.
> 
> Call Trace:
> wmab_execute
>   -> wmi_evaluate_method
>     -> acpi_evaluate_object
> 
> Thus if callers of wmab_execute() pass ACPI_ALLOCATE_BUFFER,
> the return buffer must be kfreed if wmab_execute return AE_OK.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
