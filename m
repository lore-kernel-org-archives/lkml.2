Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab2CGKTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 05:19:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35903 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab2CGKTH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 05:19:07 -0500
MIME-Version: 1.0
In-Reply-To: <1331114342-6187-1-git-send-email-avagin@openvz.org>
References: <1331114342-6187-1-git-send-email-avagin@openvz.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 7 Mar 2012 11:18:47 +0100
Message-ID: <CAPXgP13+Av39cFMxU1YNNPEc=yMjRV-pCXf-r_RHcNtDQ-xESw@mail.gmail.com>
Subject: Re: [PATCH] uevent: send events in correct order according to seqnum (v2)
To: Andrew Vagin <avagin@openvz.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 7, 2012 at 10:59, Andrew Vagin <avagin@openvz.org> wrote:
> The queue handling in the udev daemon assumes that the events are
> ordered.

> -       retval = add_uevent_var(env, "SEQNUM=%llu", (unsigned long long)seq);
> +       retval = add_uevent_var(env, "SEQNUM=%llu", (unsigned long long)++uevent_seqnum);
>        if (retval)
>                goto exit;

We need to unlock the mutex before the goto exit?

Other than that, looks good to me.

Thanks,
Kay
