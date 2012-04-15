Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305Ab2DOSgp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 14:36:45 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60905 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab2DOSgn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 14:36:43 -0400
MIME-Version: 1.0
In-Reply-To: <201204152032.36770.rjw@sisk.pl>
References: <1334310754.17013.YahooMailNeo@web161804.mail.bf1.yahoo.com>
 <201204150011.53556.rjw@sisk.pl> <1334486385.82898.YahooMailNeo@web161803.mail.bf1.yahoo.com>
 <201204152032.36770.rjw@sisk.pl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 15 Apr 2012 11:36:21 -0700
X-Google-Sender-Auth: Y-FNZdEIQw9RR5noM1Jt5ITGC9Q
Message-ID: <CA+55aFww66BY+WuTQHycGqShEtuqix9gzrjmQTsHhyuvmv9mPQ@mail.gmail.com>
Subject: Re: [PATCH] PCI: Fix regression in pci_restore_state()
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Mikko Vinni <mmvinni@yahoo.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Allen Kay <allen.m.kay@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2012 at 11:32 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> To fix the regression, make pci_restore_state() only retry the
> writes for BAR registers and only wait if the first read from
> the register doesn't return the written value.  Additionally, make
> it use msleep() instead of mdelay() for waiting.

WHAT?

msleep() is the one that can sleep. So that part of the change is just
crazy. There's no way you can sleep during PCI register restore.

                       Linus
