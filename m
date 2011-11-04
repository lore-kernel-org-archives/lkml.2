Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab1KDMeR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 08:34:17 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60844 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab1KDMeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 08:34:15 -0400
Subject: Re: virtio-pci new configuration proposal
From: Sasha Levin <levinsasha928@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Anthony Liguori <anthony@codemonkey.ws>
In-Reply-To: <20111104114033.GA21308@redhat.com>
References: <1320259767.22582.2.camel@lappy>
	 <8762j2t19l.fsf@rustcorp.com.au> <1320309203.29407.1.camel@lappy>
	 <87lirwrzlg.fsf@rustcorp.com.au>  <20111104114033.GA21308@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Date: Fri, 04 Nov 2011 14:32:19 +0200
Message-ID: <1320409939.3334.6.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-04 at 13:40 +0200, Michael S. Tsirkin wrote:
> On Fri, Nov 04, 2011 at 08:14:43PM +1030, Rusty Russell wrote:
> > > > 3) If we're changing the queue layout, it's a chance to fix a
> > > >    longstanding bug: let the guest notify the host of preferred
> > > >    queue size and alignment.
> > > 
> > > Yup, we can do that.
> 
> We don't need to change all of layout for that - just add another field
> in the common config structure to supply the alignment.

How would you do it without changing the layout? Add another optional
field at the end which will shift offsets based on whether the host and
guest support this new feature or not?

This leads to 3 different things which now shift config offsets around.

As you said, the PCI cap list was introduced both to save space (which
is not the motivation here), and because it's a very efficient and easy
way to manage optional features without requiring tricks which move
offsets around like we do now.

-- 

Sasha.

