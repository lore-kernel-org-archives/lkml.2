Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab2DPUfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:35:45 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:58617 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748Ab2DPUfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:35:42 -0400
MIME-Version: 1.0
In-Reply-To: <201204162235.49901.rjw@sisk.pl>
References: <1334310754.17013.YahooMailNeo@web161804.mail.bf1.yahoo.com>
 <201204161817.21800.rjw@sisk.pl> <1334602665.33371.YahooMailNeo@web161806.mail.bf1.yahoo.com>
 <201204162235.49901.rjw@sisk.pl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 16 Apr 2012 13:35:13 -0700
X-Google-Sender-Auth: J_OG92krd9mR-S90kdAlbQCfXmA
Message-ID: <CA+55aFyccAfEpECmD5yKYE4AquV1ZsfjRAL4coP39LmkAqrO=w@mail.gmail.com>
Subject: Re: [PATCH] PCI: Retry BARs restoration for Type 0 headers only
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Mikko Vinni <mmvinni@yahoo.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Allen Kay <allen.m.kay@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 1:35 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> Some shortcomings introduced into pci_restore_state() by commit
> 26f41062f28d ("PCI: check for pci bar restore completion and
> retry") have been fixed by recent commit ebfc5b802fa76 ("PCI: Fix
> regression in pci_restore_state(), v3"), but that commit treats
> all PCI devices as those with Type 0 configuration headers.

Make me happier and just make all of this a helper function again.
Call that helper function pci_restore_config_space(), and make the
existing "pci_restore_config_space()" be called
"pci_restore_config_space_range()" or something. Ok?

                   Linus
