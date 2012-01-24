Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446Ab2AXUye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 15:54:34 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:51686 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756446Ab2AXUyc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 15:54:32 -0500
Date: Tue, 24 Jan 2012 12:55:02 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        Dave Hansen <haveblue@us.ibm.com>, Andy Whitcroft <apw@canonical.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Matt Helsley <matthltc@us.ibm.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [RFC] fix devpts mount behavior
Message-ID: <20120124205502.GC20039@us.ibm.com>
References: <20120124000517.GA28878@sergelap>
 <CA+55aFz9ofF+Ey8VCDS8UEf2XSw36kj2RhkHfFScuzLXMeNrkA@mail.gmail.com>
 <20120124002555.GA29534@sergelap>
 <CA+55aFzwOU137V6wtyBjessx05NJo2G4KV0rvTKWvC79A+o9iQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CA+55aFzwOU137V6wtyBjessx05NJo2G4KV0rvTKWvC79A+o9iQ@mail.gmail.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12012420-5518-0000-0000-000001C52077
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds [torvalds@linux-foundation.org] wrote:
| On Mon, Jan 23, 2012 at 4:25 PM, Serge Hallyn
| <serge.hallyn@canonical.com> wrote:
| >
| > The only place that *might* be a problem is if initramsfs does a devpts
| > mount, and later init blindly mounts tmpfs on /dev and mounts a new
| > devpts.  But it seems unlikely there would be any open pty's so it
| > shouldn't really matter.
| 
| Right. I think the opportunity for problems should be pretty small.
| 
| And it's not like the pty itself wouldn't continue to work - it's just
| that programs like /usr/bin/tty wouldn't be able to *find* it.
| 
| Although who knows - maybe there is some other subtle interaction.
| 
| > I could go ahead and test that, say, ubuntu and fedora systems boot fine
| > with this change.  But of course I can't be sure there is no userspace
| > out there that won't cope...
| 
| I think the only way is to try it out.
| 
| If you can test a few distros and at least validate that the approach
| isn't *totally* broken, I'll apply it. It's early days in the -rc
| series yet, and this does seem to be one of those things that we'd be
| better off trying to do early rather than delay.

Yes, hopefully the new distros can cope with 'newinstance' as the default
and ones that can't can live with CONFIG_DEVPTS_MULTIPLE_INSTANCES=n.

Sukadev

