Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966917Ab2EQPh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 11:37:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37217 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab2EQPh1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 11:37:27 -0400
MIME-Version: 1.0
In-Reply-To: <1337266969-19181-1-git-send-email-levinsasha928@gmail.com>
References: <1337266969-19181-1-git-send-email-levinsasha928@gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 17 May 2012 17:37:05 +0200
Message-ID: <CAPXgP10EyOz9-GHhj2ubtudtpaGCHbshDyJywjqJGGMu_xkQDA@mail.gmail.com>
Subject: Re: [RFC] printk: add relative printk timing support
To: Sasha Levin <levinsasha928@gmail.com>
Cc: greg@kroah.com, torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, joe@perches.com, hpa@kernel.org,
        yinghai@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 5:02 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
> This patch adds support for relative timestamps in printk output.

>  static size_t print_prefix(const struct log *msg, bool syslog, char *buf)

> +       } else if (printk_time == 2 || printk_time == 3) {
> +               static unsigned long long last_print;

We can have multiple concurrent users of the relative time calculation, right?

I guess the last_print needs to be localized to every possible user
and concurrent instance: syslog(dmesg),  syslog(/proc/kmsg), console
output, to not race against each other?

Kay
