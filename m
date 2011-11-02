Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818Ab1KBPKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 11:10:31 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42886 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932280Ab1KBPK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 11:10:28 -0400
Date: Wed, 2 Nov 2011 08:10:39 -0700
From: Tejun Heo <tj@kernel.org>
To: MyungJoo Ham <myungjoo.ham@gmail.com>
Cc: David Fries <david@fries.net>, netdev@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] hiberante hangs TCP Re: [EXAMPLE CODE] Parasite
 thread injection and TCP connection hijacking
Message-ID: <20111102151039.GA12543@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20110806121247.GC23937@htj.dyndns.org>
 <20111030044821.GA23741@spacedout.fries.net>
 <20111030201618.GA7696@google.com>
 <CAJ0PZbSRX6Rqn5NnnMkVGrPovtSuc2NWasysOYnjr3j9rON1VQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ0PZbSRX6Rqn5NnnMkVGrPovtSuc2NWasysOYnjr3j9rON1VQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Nov 02, 2011 at 06:44:31PM +0900, MyungJoo Ham wrote:
> > Hmmm... sounds like taking down network interfaces before starting
> > hibernation sequence should be enough, which shouldn't be too
> > difficult to implement from userland.  Rafael, what do you think?
> >
> > Thanks.
> 
> Um... it seems that the "thaw" callbacks of network interfaces or TCP
> should do something on this.
> 
> Probably, the "thaw" callbacks should make sure that the TCP
> connections are closed?

I don't think it's a good idea to diddle with TCP connections from
that layer.  From what I understand, it seem all we need is plugging
tx/rx while preparing for hibernation.  That shouldn't be too
difficult.

Thanks.

-- 
tejun
