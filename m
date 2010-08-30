Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab0H3SUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 14:20:24 -0400
Received: from smtp-out.google.com ([216.239.44.51]:30242 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab0H3SUX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 14:20:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Hg69KHeWXhN93t34N6WRnlNEMHE6jn6zLrBwlXMEJbt2NcLycCvLgYCUG9IeZCzJOr
         DBdXz/PSBkGGsjEDKrFw==
MIME-Version: 1.0
In-Reply-To: <4C7B54C0.7080008@cn.fujitsu.com>
References: <4C7B54C0.7080008@cn.fujitsu.com>
Date: Mon, 30 Aug 2010 11:20:18 -0700
Message-ID: <AANLkTinCW-U2aOUh7yHM3mBdKAdeGiY-MvbvowFe5p-j@mail.gmail.com>
Subject: Re: [RFC] [PATCH] cfq-iosched: add cfq group hierarchical scheduling support
From: Chad Talbott <ctalbott@google.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Jeff Moyer <jmoyer@redhat.com>, Divyesh Shah <dpshah@google.com>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Nauman Rafique <nauman@google.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 29, 2010 at 11:50 PM, Gui Jianfeng
<guijianfeng@cn.fujitsu.com> wrote:
>  o Each cfq group has its own group service tree.
>  o Each cfq group contains a "group schedule entity" (gse) that
>    schedules on parent cfq group's service tree.
>  o Each cfq group contains a "queue schedule entity"(qse), it
>    represents all cfqqs located on this cfq group. It schedules
>    on this group's service tree. For the time being, root group
>    qse's weight is 1000, and subgroup qse's weight is 500.
>  o All gses and qse which belones to a same cfq group schedules
>    on the same group service tree.

Overall, I like this approach.  It's similar to what we are using with
earlier hierarchical patches.  Can you improve the naming a little
bit?  "qse" and "gse" look almost identical and breaks my brain.
Maybe "queue_entity" and "group_entity"?  If entity is to much to
type, then "item"?

Chad
