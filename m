Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab1HVQYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 12:24:45 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35167 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab1HVQYn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 12:24:43 -0400
MIME-Version: 1.0
In-Reply-To: <1314021094-15453-1-git-send-email-mbroz@redhat.com>
References: <4E4ECA5D.1020907@redhat.com> <1314021094-15453-1-git-send-email-mbroz@redhat.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 22 Aug 2011 18:24:19 +0200
Message-ID: <CAPXgP10dYJv0aS_WwUqJr=YEz7WVp1abvED=fKEmOPp42ZRP6A@mail.gmail.com>
Subject: Re: [PATCH] kobj_uevent: Ignore if some listeners cannot handle message
To: Milan Broz <mbroz@redhat.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, ebiederm@xmission.com,
        greg@kroah.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 15:51, Milan Broz <mbroz@redhat.com> wrote:
> kobject_uevent() uses a multicast socket and should ignore
> if one of listeners cannot handle messages or nobody is
> listening at all.
>
> Easily reproducible when a process in system is cloned
> with CLONE_NEWNET flag.

> -                       if (retval == -ENOBUFS)
> +                       if (retval == -ENOBUFS || retval == -ESRCH)

Looks good to me.

Kay
