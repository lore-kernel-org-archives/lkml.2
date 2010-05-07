Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab0EGLbf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 07:31:35 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45361 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752604Ab0EGLbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 07:31:33 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-arch@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: kbuild: fixing the select problem
References: <1273096160.23208.35.camel@mulgrave.site>
Date: Fri, 07 May 2010 12:31:19 +0100
In-Reply-To: <1273096160.23208.35.camel@mulgrave.site> (James Bottomley's
	message of "Wed, 05 May 2010 17:49:20 -0400")
Message-ID: <tnxtyqkdk3c.fsf@e102109-lin.cambridge.arm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 07 May 2010 11:31:23.0949 (UTC) FILETIME=[D2D6C5D0:01CAEDD8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> The select problem is that the kbuild select directive will turn a
> symbol on without reference to its dependencies.  This, in turn, means
> that either selected symbols must select their dependencies, or that
> people using select have to be aware of the selected symbol's dependency
> and build those dependencies into their symbol (leading to duplication
> and the possibility of getting the dependencies out of sync).  We use
> select for the scsi transport classes, so we run into this problem in
> SCSI quite a lot.
>
> I think the correct fix is to make a symbol that selects another symbol
> automatically inherit all of the selected symbol's dependencies.

You may want to have a look at a patch I proposed some time ago, which
at just warns of selecting options with unmet dependencies. I think it's
a better approach that forcing the selection of the dependencies:

http://lkml.org/lkml/2009/9/16/413

-- 
Catalin
