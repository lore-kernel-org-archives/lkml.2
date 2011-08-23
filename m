Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab1HWWNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 18:13:11 -0400
Received: from smtp-out.google.com ([216.239.44.51]:16546 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982Ab1HWWNG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 18:13:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=vKuPke/Oabe+cJkp4G7ff6wxkV8h5wBwtf/1GWmgtD1ZlSH3dnbAb/TrTCd69bwuc
	lRgf/OTA1EdraxmiHVneQ==
MIME-Version: 1.0
In-Reply-To: <CAEcckGqfDUt=b9gdQAJHug__eht2tQymg95UXp3rERBp+oyDvg@mail.gmail.com>
References: <1314136075-8784-1-git-send-email-thieule@chromium.org>
	<20110823215924.GN2203@ZenIV.linux.org.uk>
	<CAEcckGqfDUt=b9gdQAJHug__eht2tQymg95UXp3rERBp+oyDvg@mail.gmail.com>
Date: Tue, 23 Aug 2011 15:13:04 -0700
X-Google-Sender-Auth: uaXII0SyrGt5hazStOI-19rpDas
Message-ID: <CAEcckGoCBdOk4SoWGwVfWbXbZVWjy6Hvmc5tWCKEg+Bvd6FJsw@mail.gmail.com>
Subject: Re: [PATCH] vfs: Export do_fallocate() to kernel modules
From: Thieu Le <thieule@chromium.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Resending in text format]

ecryptfs, in the past, uses a write-through cache model.  Whenever an
application writes data to the file system, ecryptfs would encrypt the
entire page and write it to the lower file system.  So in the case
where an application performs multiple writes to the same page,
ecryptfs would encrypt the entire page for each write.  Recently,
ecryptfs moved to a write-back model where it would only encrypt the
page when the page is flushed to disk, thereby reducing the number of
encryption operations.  However, if the lower file system is low on
disk space, the delayed write by ecryptfs to the lower file may fail
with -ENOSPC.  In order to prevent this, ecryptfs needs to efficiently
preallocate the space in the lower file which is why the need for
fallocate.

On Tue, Aug 23, 2011 at 2:59 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Tue, Aug 23, 2011 at 02:47:55PM -0700, Thieu Le wrote:
> > Export do_fallocate() so layered file systems such as ecryptfs can take
> > advantage of this interface.  Existing interfaces to the fallocate
> > facilities require a file descriptor which is not available to layered
> > file systems.
>
> Details, please.  do_fallocate() does shitloads of checks, probably pointless
> for ecryptfs and its ilk, but I want to see users for that export before
> I can say whether it's OK or not.
