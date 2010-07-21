Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab0GUPNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 11:13:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:38321 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567Ab0GUPNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 11:13:32 -0400
Message-ID: <4C470E69.7020900@kernel.org>
Date: Wed, 21 Jul 2010 17:12:41 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Christian Dietrich <stettberger@dokucode.de>
CC: David Howells <dhowells@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: Dead Config in mm/percpu.c
References: <861vaxjij8.fsf@peer.zerties.org>
In-Reply-To: <861vaxjij8.fsf@peer.zerties.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 21 Jul 2010 15:12:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2010 11:22 AM, Christian Dietrich wrote:
> Hi all!
>        
>         As part of the VAMOS[0] research project at the University of
> Erlangen we are looking at multiple integrity errors in linux'
> configuration system.
> 
>         I've been running a check on the mm/ sourcetree for
> config Items not defined in Kconfig and found 1 such case. Sourcecode
> blocks depending on these Items are not reachable from a vanilla
> kernel -- dead code. I've seen such dead blocks made on purpose
> e.g. while integrating new features into the kernel but generally
> they're just useless.
> 
> We found, that CONFIG_NEED_PER_CPU_KM is a dead symbol, so it isn't defined
> anywhere. Cause of that the percpu_km.c is never included anywhere. Is
> this a intended dead symbol, for use in out of tree development, or is
> this just an error?

Oh, it's new code waiting to be used.  It's for cases where SMP is
used w/o MMU.  IIRC, it was blackfin.

Thanks.

-- 
tejun
