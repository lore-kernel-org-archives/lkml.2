Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab2K1U0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 15:26:55 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:35435 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896Ab2K1U0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 15:26:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: linux-acpi@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Acpi deadlocks with 3.7.0-rc4
Date: Wed, 28 Nov 2012 21:31:38 +0100
Message-ID: <6072715.FoXSX1UJhO@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc7; KDE/4.9.3; x86_64; ; )
In-Reply-To: <50B64996.1010709@redhat.com>
References: <50A513A8.9010404@redhat.com> <CA+55aFy7hxayPzr3MiV1xc0bvLcd+-7b52iA3CYhbPZuWXr9yA@mail.gmail.com> <50B64996.1010709@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 28, 2012 06:27:50 PM Zdenek Kabelac wrote:
> Dne 28.11.2012 18:02, Linus Torvalds napsal(a):
> > On Wed, Nov 28, 2012 at 8:21 AM, Zdenek Kabelac <zkabelac@redhat.com> wrote:
> >>
> >> I've opened  https://bugzilla.kernel.org/show_bug.cgi?id=51071
> >> and attached picture there which is all I have.

I wonder if you can try to apply the patch below and see if that makes any
difference?

Rafael


---
 drivers/pnp/pnpacpi/rsparser.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- linux.orig/drivers/pnp/pnpacpi/rsparser.c
+++ linux/drivers/pnp/pnpacpi/rsparser.c
@@ -610,6 +610,14 @@ int pnpacpi_build_resource_template(stru
 	struct acpi_resource *resource;
 	int res_cnt = 0;
 	acpi_status status;
+	int ret;
+
+	/* Sanity check. */
+	ret = acpi_bus_get_device(handle, &acpi_dev);
+	if (ret) {
+		dev_err(&dev->dev, "ACPI node is invalid in %s\n", __func__);
+		return ret;
+	}
 
 	status = acpi_walk_resources(handle, METHOD_NAME__CRS,
 				     pnpacpi_count_resources, &res_cnt);



-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
