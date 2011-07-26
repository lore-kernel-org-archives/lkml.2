Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab1GZSk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 14:40:56 -0400
Received: from smtp-out.google.com ([74.125.121.67]:8167 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab1GZSkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 14:40:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=BxUzY7XigtAarPfJvgHjpJy6AAoVhXCMszXWxUi+czGYQDgBVB7cCjJv9oQdaZQCW
	U64OHMck64ZFuBPTlcwfA==
MIME-Version: 1.0
In-Reply-To: <20110726174148.GC13780@redhat.com>
References: <1311573834-7140-1-git-send-email-gaowanlong@cn.fujitsu.com>
 <1311645400-19434-1-git-send-email-gaowanlong@cn.fujitsu.com>
 <20110726144427.GB13780@redhat.com> <CAJniumVm=oH_yJAgaTzwVu1XwJfn8eAsHw2Cm0tfvg=unA6hkA@mail.gmail.com>
 <20110726174148.GC13780@redhat.com>
From: Paul Menage <menage@google.com>
Date: Tue, 26 Jul 2011 11:40:26 -0700
Message-ID: <CAJniumW-+aQE0jWr0NhvTUuxLDiP27bQaZVmVORpnNHvPqp0kQ@mail.gmail.com>
Subject: Re: [PATCH v3] blk-cgroup:be able to remove the record of unplugged device
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>, lizf@cn.fujitsu.com,
        axboe@kernel.dk, linux-kernel@vger.kernel.org, wanlong.gao@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 10:41 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> They have but the context where temp is being used to figure out if it
> is a deletion rule is generic. So if a rule is being deleted (be it
> weight, bps or iops), we are going to parse it early in the function.
> So in that context not calling it "weight" makes sense to me.
>
> We use bps, iops names only after knowing the value type.

Fair enough - but in that case, wouldn't it make sense to make "temp"
a u64 and just parse it once, rather than reparsing the iops/bps later
in their switch cases?

Paul
