Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251Ab0JHKT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 06:19:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58459 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab0JHKTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 06:19:23 -0400
Date: Fri, 8 Oct 2010 11:19:21 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/18] fs: introduce a per-cpu last_ino allocator
Message-ID: <20101008101921.GD19804@ZenIV.linux.org.uk>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-16-git-send-email-david@fromorbit.com>
 <87d3rl5c1h.fsf@basil.nowhere.org>
 <20101008095824.GB19804@ZenIV.linux.org.uk>
 <20101008100944.GE13352@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008100944.GE13352@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 12:09:44PM +0200, Andi Kleen wrote:

> > Can be done if you bother to add ->getattr() for those, but you'll need
> > to do some kind of lazy allocation of inumbers for those; fstat() _will_
> > want st_ino.
> 
> Why not just put 0 in st_ino for sockets/pipes/etc. ? 

Because it's a userland-visible change; right now you can compare
i_ino for sockets...
