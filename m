Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab2A0UKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 15:10:30 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44560 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab2A0UK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 15:10:28 -0500
Date: Sat, 28 Jan 2012 00:10:22 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        ebiederm@xmission.com, xemul@openvz.org, xemul@parallels.com,
        serge.hallyn@canonical.com, keescook@chromium.org,
        kamezawa.hiroyu@jp.fujitsu.com, adobriyan@gmail.com, tj@kernel.org,
        avagin@openvz.org, segoon@openwall.com
Subject: Re: [RFC c/r 3/4] c/r: procfs: add arg_start/end, env_start/end and
 exit_code members to /proc/$pid/stat
Message-ID: <20120127201022.GP11086@moon>
References: <20120127175342.273260614@openvz.org>
 <20120127175939.862102158@openvz.org>
 <4F230265.8050506@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F230265.8050506@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 03:00:37PM -0500, KOSAKI Motohiro wrote:
...
> 
> > +
> > +		seq_printf(m, "%d\n", task->exit_code);
> > +
> 
> Bad this part seems to make new side channel. exit_code is one of
> inter process communication messages. IPC messages should NOT be
> observed from completely unrelated proesses.
> 

You mean we need "permitted" test here, right?

	Cyrill
