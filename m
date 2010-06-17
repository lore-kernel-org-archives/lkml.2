Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760116Ab0FQOKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 10:10:41 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64574 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab0FQOKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 10:10:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=mT5N6KKt/ysPeZwlDP5Q87loxGcmFhfbrLEgxiH9go+gJKyRfHUsjIcQA4u7bM+5Ww
         OFIHCFuE0SpluqOkVNoGsHxNui3TYqs69TTOdBwPj/KJZVjoS0FhRzfxTt2NOzJEpi35
         4D7Cb0dNiLyAs1CfOVruhUOXJUZI6Asa1UyWI=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1006170844300.22997@router.home>
References: <20100617155420.GB2693@localhost.localdomain>
	<alpine.DEB.2.00.1006170844300.22997@router.home>
Date: Thu, 17 Jun 2010 22:10:39 +0800
Message-ID: <AANLkTimYX9PqGJq3dw2n3FZQiIkX0nOKMEOHdYMndHWo@mail.gmail.com>
Subject: Re: [PATCH] Slabinfo: Fix display format
From: wzt wzt <wzt.wzt@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, penberg@cs.helsinki.fi,
       mpm@selenic.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 9:45 PM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> On Thu, 17 Jun 2010, wzt.wzt@gmail.com wrote:

> This one may break user space tools that have assumptions about the length
> of the field. Or do tools not make that assumption?
>

User space tools usually use sscanf() to extract this field like:
sscanf(buff, "%s %d", name, &num);
If %-27s can break some user space tools that have assumptions about
the length of the field, the orig %-17s can also break it.
The longest name inotify_event_private_data is 26 bytes in 2.6.34-rc2,
the tools still can't extract it.
