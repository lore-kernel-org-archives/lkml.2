Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab0FNXsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 19:48:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39988 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab0FNXsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 19:48:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=och6UqdLlZR9tPFz9cCt6rkmwSj2UBBvhDsbEH4I7oEIvgtPOHyUqkpgEGJRhdXtV/
         yXgJcqn/FQdz23jHrSoepfCFl+ScR87+I9Pg4hwtGQu1CJGKH+kidTkC959aMQAAdTLN
         ds6/SMw1RqandPOgtlv8Lkp871mbpE3llMGkY=
Subject: Re: [PATCH v2] MMC: fix all hangs related to mmc/sd card
 insert/removal during suspend/resume.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mmc <linux-mmc@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Philip Langdale <philipl@overt.org>
In-Reply-To: <20100614155157.dca38e09.akpm@linux-foundation.org>
References: <1276283791.8557.29.camel@maxim-laptop>
	 <1276283995-10812-1-git-send-email-maximlevitsky@gmail.com>
	 <20100614155157.dca38e09.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Jun 2010 02:48:33 +0300
Message-ID: <1276559313.7837.41.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-14 at 15:51 -0700, Andrew Morton wrote: 
> On Fri, 11 Jun 2010 22:19:55 +0300
> Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > If you don't use CONFIG_MMC_UNSAFE_RESUME, card will now be removed
> > in pm notified while userspace is still running.
> > Thus it will be possible to sync it propely.
> 
> That paragraph is a disaster and I'm not sure that I understand it well
> enough to repair it.  I think you wanted s/now/not/ and s/in/if/ and
> s/it will be/it will not be/.  Or perhaps you didn't.
> 
> Please send a comprehensible replacement.
> 

Sure.



If you don't use CONFIG_MMC_UNSAFE_RESUME, as soon as you attempt to
suspend, the card will be removed, therefore this patch doesn't change
the behavior of this option.

However the removal will be done by pm notifier, which runs while
userspace is still not frozen and thus can freely use del_gendisk,
without the risk of deadlock which would happen otherwise.

If you do use 


Best regards,
Maxim Levitsky

