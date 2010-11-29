Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab0K2DF2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 22:05:28 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54791 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab0K2DF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 22:05:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ThGXP69bJLNlxgQRXn6W1BVFepWDiIK7Rw5Th3CjWuDl/iecR10UrK9GsfyFRStUnF
         EnxBfHMyrcVfhACyoK5L10QgwNXkzKLq5GGa3BPgJFWAy3frWS+1tLjTHKhMJM2D3vkM
         tg7R4WLy9bUd4DS6T6EIKvRr+9UMP61yT7OuY=
Date: Mon, 29 Nov 2010 11:10:17 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Pavel Vasilyev <pavel@pavlinux.ru>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Repalce strncmp by memcmp
Message-ID: <20101129031017.GB5218@cr0.nay.redhat.com>
References: <4CF30B46.4000203@pavlinux.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF30B46.4000203@pavlinux.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 05:09:10AM +0300, Pavel Vasilyev wrote:
>
>    This patch replace all strncmp(a, b, c) by  memcmp(a, b, c).
>
>I test on x86_64 (AMD Opteron 285).
>
>#include <string.h>
>char *A = "0000";
>void test_memcmp(void) {
>        memcmp(A, "TEST", 4);
>}
>void test_strn(void) {
>        strncmp(A, "TEST", 4);
>}

This is plain wrong, memcmp() doesn't handle the case that 'a'
is shorter than 'b', it may access beyond '\0'.
