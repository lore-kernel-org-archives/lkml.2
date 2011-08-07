Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab1HGTca (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 15:32:30 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46792 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab1HGTc1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 15:32:27 -0400
MIME-Version: 1.0
In-Reply-To: <20110807174829.GY2203@ZenIV.linux.org.uk>
References: <CAH2r5mszsiu2Gm-DPbfT8UReT=eBTf4Du4eyEapG8Ayn7UN1pw@mail.gmail.com>
	<20110807174829.GY2203@ZenIV.linux.org.uk>
Date: Sun, 7 Aug 2011 14:32:26 -0500
Message-ID: <CAH2r5mvxRfrAUA9kXwCojg_0_YTC=W623A-tqERBkeWL5pvf6g@mail.gmail.com>
Subject: Re: new sparse warning fs/cifs/cifsfs.c:168:15: warning: dereference
 of noderef expression fs/cifs/cifsfs.c:542:15: warning: dereference of
 noderef expression
From: Steve French <smfrench@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 7, 2011 at 12:48 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sun, Aug 07, 2011 at 11:22:51AM -0500, Steve French wrote:
>> I noticed a series of sparse warnings (on all calls to cifs's GetXid
>> after building on a newly install fc15 system (yum installed a sparse
>> binary dated June 23).
>>
>> fs/cifs/cifsfs.c:168:15: warning: dereference of noderef expression
>> fs/cifs/cifsfs.c:542:15: warning: dereference of noderef expression
>>
>> Has sparse changed to add a new warning - I see (from quick search)
>> others getting this on other modules years ago, but I didn't see
>> anything obvious wrong with the definition of the function, and I
>> hadn't noticed sparse complaining about it before, and would like to
>> remove the 50+ new messages as they clutter the build output.
>
> It's not sparse change - the whinge comes from current_fsuid(), i.e. direct
> read of current->cred, even though it's declared with __rcu.  The thing is,
> current->cred does *not* need rcu_dereference() - only the task itself
> can change it.  Easily fixed...

your change makes sense - thx


Steve
