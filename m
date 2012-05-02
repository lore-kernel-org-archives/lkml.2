Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460Ab2EBUys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 16:54:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40960 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756407Ab2EBUyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 16:54:45 -0400
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 May 2012 16:54:45 EDT
Message-ID: <4FA19DC8.2030001@redhat.com>
Date: Wed, 02 May 2012 22:49:12 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120425 Thunderbird/12.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>,
        James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to partition
References: <1335953452-10460-1-git-send-email-jack@suse.cz> <4FA1092E.9090603@redhat.com> <20120502135123.GF16976@quack.suse.cz> <4FA13DDF.9010006@redhat.com> <20120502161038.01ee9b59@pyramind.ukuu.org.uk> <4FA157A6.7050209@redhat.com>
In-Reply-To: <4FA157A6.7050209@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 02/05/2012 17:49, Paolo Bonzini ha scritto:
>> > Customisable filters are not hard. We've got all the filtering code in
>> > kernel and the ability to verify filters, even the ability to JIT them.
>> > Just support adding/removing/running a BPF filter on the channel in
>> > question.
>> > 
>> > So it shouldn't be much code to do what you want.
> Yes, it's not much code if I don't get into cgroups land and stick with
> a ioctl to add and remove BPF filters that look at CDBs.

Except that then I need to access some "struct file" member in SG_IO,
thus changing ioctl from block_device/fmode to block_device/file.  This
would partially undo the 2007 switch from inode/file by Al Viro.
Somehow I'm not that optimist anymore, though I'd be happy to be proven
wrong.

Paolo

