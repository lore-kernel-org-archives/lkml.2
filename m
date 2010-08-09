Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab0HIScN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 14:32:13 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33049 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab0HIScM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 14:32:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=UUkKKYUVYnC0obN3M7Qkhfk2cXEQ2yw0V5jDrrhHdEyzrJpNNSMfqe8FNUlmMEjV8s
         Eyb6j+Yz+gBwQm+XduT0Igp8S1UNs/yR6knP4h+yLwql0XHR8RLZeJ1NfR8eGSmO1w22
         Uu73BxjEao1jzVSpIWd7d1d6bWsr0Mo6ETqMk=
MIME-Version: 1.0
In-Reply-To: <1281374816-904-8-git-send-email-ngupta@vflare.org>
References: <1281374816-904-1-git-send-email-ngupta@vflare.org>
	<1281374816-904-8-git-send-email-ngupta@vflare.org>
Date: Mon, 9 Aug 2010 21:32:11 +0300
X-Google-Sender-Auth: Kr7sn1hLNaeprvjyouI0-d1WYCc
Message-ID: <AANLkTikwN08QsfRNwa-4=qOu8mKkGoEUHdxUC5n8u3Ve@mail.gmail.com>
Subject: Re: [PATCH 07/10] Increase compressed page size threshold
From: Pekka Enberg <penberg@kernel.org>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Linux Driver Project <devel@driverdev.osuosl.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nitin,

On Mon, Aug 9, 2010 at 8:26 PM, Nitin Gupta <ngupta@vflare.org> wrote:
> Compression takes much more time than decompression. So, its quite
> wasteful in terms of both CPU cycles and memory usage to have a very
> low compressed page size threshold and thereby storing such not-so-well
> compressible pages as-is (uncompressed). So, increasing it from
> PAGE_SIZE/2 to PAGE_SIZE/8*7. A low threshold was useful when we had
> "backing swap" support where we could forward such pages to the backing
> device (applicable only when zram was used as swap disk).
>
> It is not yet configurable through sysfs but may be exported in future,
> along with threshold for average compression ratio.
>
> Signed-off-by: Nitin Gupta <ngupta@vflare.org>

The description makes sense but lacks any real data. What kind of
workloads did you test this with? Where does it help most? How much?

                        Pekka
