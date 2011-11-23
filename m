Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab1KWFyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 00:54:38 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44255 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab1KWFyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 00:54:37 -0500
Date: Tue, 22 Nov 2011 22:53:51 -0700
From: Jean Sacren <sakiwit@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Reinhard Tartler <Reinhard.Tartler@informatik.uni-erlangen.de>,
        Arnaud Lacombe <lacombar@gmail.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        vamos-dev@lists.informatik.uni-erlangen.de, amwang@redhat.com,
        sakiwit@gmail.com
Subject: Re: [PATCH] kconfig: Fix checking return value of 'fwrite'
Message-ID: <20111123055351.GB14454@mail.gmail.com>
References: <87lisype1v.fsf@faui43f.informatik.uni-erlangen.de>
 <CACqU3MWZuqgpxG7FSvr2LkqTqwF-gQM8hQSnTTpHpcWT2LHGNA@mail.gmail.com>
 <4EC8FF93.7010706@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC8FF93.7010706@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Marek <mmarek@suse.cz>
Date: Sun, 20 Nov 2011 14:24:35 +0100
>
> On 7.10.2011 05:29, Arnaud Lacombe wrote:
> > Hi,
> > 
> > 2011/10/6 Reinhard Tartler <Reinhard.Tartler@informatik.uni-erlangen.de>:
> >> fwrite indicates '1' written member if a zero-length string is written.
> > you forgot the "Signed-off-by: " part :)
> 
> Reinhard, can I assume
> 
> Signed-off-by: Reinhard Tartler
> <Reinhard.Tartler@informatik.uni-erlangen.de>
> 
> ? The patch is otherwise correct.

I have two reasons to oppose this patch.

1. If 'len' value is zero, there is an issue already and it should be
taken care of _before_ calling fwrite().

2. xfwrite() doesn't fix anything except for the compiler warning. It
assumes this world is perfect and it's definitely not a place to take
care of the zero-length string.

-- 
Jean Sacren
