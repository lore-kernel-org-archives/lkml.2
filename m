Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391Ab1GZHct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 03:32:49 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58529 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab1GZHcn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 03:32:43 -0400
MIME-Version: 1.0
In-Reply-To: <1311630170-26057-22-git-send-email-jim.cromie@gmail.com>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com> <1311630170-26057-22-git-send-email-jim.cromie@gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 26 Jul 2011 09:32:22 +0200
X-Google-Sender-Auth: etXKtIlLEiYyB2ohIf_kzzmL0b0
Message-ID: <CAO+b5-rP+s7QgObFfudiM9wsVjfXVrVeWs9-OtTsp70rX-te+Q@mail.gmail.com>
Subject: Re: [PATCH 21/25] dynamic_debug: shrink struct pending query to size
 actually needed
To: Jim Cromie <jim.cromie@gmail.com>
Cc: jbaron@redhat.com, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 11:42 PM, Jim Cromie <jim.cromie@gmail.com> wrote:
> -       pr_debug("query saved as pending %d\n", pending_ct);
> +       pr_debug("query saved as pending %d, in %d+%d bytes\n",
> +               pending_ct, sizeof(struct pending_query), buflen);

The proper format specifier for size_t is %zd, not %d. Does this mean
that this code has not yet been compiled on a 64-bit system ?

Bart.
