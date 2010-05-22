Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935720Ab0EVBrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 21:47:39 -0400
Received: from mail-qy0-f171.google.com ([209.85.221.171]:48250 "EHLO
	mail-qy0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935688Ab0EVBrh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 21:47:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ByAxSsnE15AZxQCRDkw4tNqioZ91W0lzrKtd+n2nftp1HLufXnF2RVsVvChiGvTjQU
         oU0xmylWZlj4E/sFFFe/uQ6cTAdOE31QTy3nO+1mV2uKTLOw4nmoccobCfR+ldg+sEbC
         zI0maCns0xyQWYlhGDUMSD36xnE6zxWNhMqjQ=
MIME-Version: 1.0
In-Reply-To: <1274461422-18433-3-git-send-email-josef@redhat.com>
References: <1274461422-18433-1-git-send-email-josef@redhat.com>
	 <1274461422-18433-3-git-send-email-josef@redhat.com>
Date: Fri, 21 May 2010 18:47:36 -0700
X-Google-Sender-Auth: NzZEkjqsPwoB2UcZPD7g8dY7K_Q
Message-ID: <AANLkTikwPL8-WefVIMF1ldTZpWVHvS1Lbh4YB8MZ4eu0@mail.gmail.com>
Subject: Re: [PATCH 3/6] direct-io: do not merge logically non-contiguous 
	requests
From: Mike Fedyk <mfedyk@mikefedyk.com>
To: Josef Bacik <josef@redhat.com>
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@infradead.org,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 10:03 AM, Josef Bacik <josef@redhat.com> wrote:
> Btrfs cannot handle having logically non-contiguous requests submitted.  For
> example if you have
>
> Logical:  [0-4095][HOLE][8192-12287]
> Physical: [0-4095]      [4096-8191]
>
> Normally the DIO code would put these into the same BIO's.  The problem is we
> need to know exactly what offset is associated with what BIO so we can do our
> checksumming and unlocking properly, so putting them in the same BIO doesn't
> work.  So add another check where we submit the current BIO if the physical
> blocks are not contigous OR the logical blocks are not contiguous.
>
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>
> V1->V2
> -Be more verbose in the in-code comment
>
>  fs/direct-io.c |   20 ++++++++++++++++++--
>  1 files changed, 18 insertions(+), 2 deletions(-)
>

Btrfs has been pretty much self-contained (working well compiled
against 2.6.32 for example).  Is there a way that this wouldn't just
start silently breaking for people compiling the latest btrfs with
dkms against older kernels?
