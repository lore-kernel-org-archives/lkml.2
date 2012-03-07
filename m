Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab2CGLDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 06:03:42 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:37716 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254Ab2CGLDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 06:03:39 -0500
MIME-Version: 1.0
In-Reply-To: <1331117396-11600-1-git-send-email-avagin@openvz.org>
References: <1331117396-11600-1-git-send-email-avagin@openvz.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 7 Mar 2012 12:03:19 +0100
Message-ID: <CAPXgP12kQm9dZdjh3Vch2ebrn21jW6r-=gVssmvU3WqJ6VE70g@mail.gmail.com>
Subject: Re: [PATCH] uevent: send events in correct order according to seqnum (v3)
To: Andrew Vagin <avagin@openvz.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 7, 2012 at 11:49, Andrew Vagin <avagin@openvz.org> wrote:
> The queue handling in the udev daemon assumes that the events are
> ordered.
>
> Before this patch uevent_seqnum is incremented under sequence_lock,
> than an event is send uner uevent_sock_mutex. I want to say that code
> contained a window between incrementing seqnum and sending an event.
>
> This patch locks uevent_sock_mutex before incrementing uevent_seqnum.
>
> v2: delete sequence_lock, uevent_seqnum is protected by uevent_sock_mutex
> v3: unlock the mutex before the goto exit
>
> Thanks for Kay for the comments.
>
> Signed-off-by: Andrew Vagin <avagin@openvz.org>

Looks good to me. Works fine in a kvm installation here.
Feel free to add:
  Tested-By: Kay Sievers <kay.sievers@vrfy.org>

Thanks lot for the udev debugging and taking care of it,
Kay
