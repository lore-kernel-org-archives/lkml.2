Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933545Ab2EWOZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 10:25:52 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:52066 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758163Ab2EWOZu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 10:25:50 -0400
MIME-Version: 1.0
In-Reply-To: <4FBB3A23.50102@cn.fujitsu.com>
References: <4FBB3A23.50102@cn.fujitsu.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 23 May 2012 08:25:29 -0600
Message-ID: <CAErSpo4cUwwJNq45GZhUW02FU+T72OmvGfNcd2d1WhFo86KFOw@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86: add max_addr boot option
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: rob@landley.net, tglx@linutronix.de, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 1:02 AM, Wen Congyang <wency@cn.fujitsu.com> wrote:

> +       if (start >= max_addr) {
> +               printk(KERN_INFO "Ingoring memory: %016Lx - %016Lx\n",
> +                      (unsigned long long)start,
> +                      (unsigned long long)(start + size));
> +               return;
> +       }
> +
> +       if (max_addr - start < size) {
> +               printk(KERN_INFO "Ingoring memory: %016Lx - %016Lx\n",
> +                      (unsigned long long)max_addr,
> +                      (unsigned long long)(start + size));
> +               size = max_addr - start;

s/Ingoring/Ignoring/

Please use a format like "e820: ignoring [mem %#010Lx-%#010Lx]" so it
matches other places where we print physical address ranges.  See
https://lkml.org/lkml/2012/2/13/436

Bjorn
