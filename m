Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933414Ab0FCAVL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 20:21:11 -0400
Received: from claw.goop.org ([74.207.240.146]:41489 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933348Ab0FCAVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 20:21:08 -0400
Message-ID: <4C06F571.3050306@goop.org>
Date: Wed, 02 Jun 2010 17:21:05 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>, chris.mason@oracle.com,
       viro@zeniv.linux.org.uk, adilger@Sun.COM, tytso@mit.edu,
       mfasheh@suse.com, joel.becker@oracle.com, matthew@wil.cx,
       linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
       ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, ngupta@vflare.org,
       JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@suse.de,
       dave.mccracken@oracle.com, riel@redhat.com, avi@redhat.com,
       konrad.wilk@oracle.com
Subject: Re: [PATCH V2 2/7] Cleancache (was Transcendent Memory): core files
References: <20100528173550.GA12219@ca-server1.us.oracle.com 20100602122900.6c893a6a.akpm@linux-foundation.org> <0be9e88e-7b0d-471d-8d49-6dc593dd43be@default>
In-Reply-To: <0be9e88e-7b0d-471d-8d49-6dc593dd43be@default>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2010 05:06 PM, Dan Magenheimer wrote:
> It is intended that there be different flavours but only
> one can be used in any running kernel.  A driver file/module
> claims the cleancache_ops pointer (and should check to ensure
> it is not already claimed).  And if nobody claims cleancache_ops,
> the hooks should be as non-intrusive as possible.
>
> Also note that the operations occur on the order of the number
> of I/O's, so definitely a lot, but "zillion" may be a bit high. :-)
>
> If you think this is a showstoppper, it could be changed
> to be bound only at compile-time, but then (I think) the claimer
> could never be a dynamically-loadable module.
>   

Andrew is suggesting that rather than making cleancache_ops a pointer to
a structure, just make it a structure, so that calling a function is a
matter of cleancache_ops.func rather than cleancache_ops->func, thereby
avoiding a pointer dereference.

    J
