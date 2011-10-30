Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934300Ab1J3RSu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 13:18:50 -0400
Received: from tango.0pointer.de ([85.214.72.216]:48499 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934231Ab1J3RSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 13:18:49 -0400
Date: Sun, 30 Oct 2011 18:18:46 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Menage <paul@paulmenage.org>, Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel@vger.kernel.org, harald@redhat.com, david@fubar.dk,
        greg@kroah.com
Subject: Re: A =?utf-8?Q?Plumber=E2=80=99?=
	=?utf-8?Q?s?= Wish List for Linux
Message-ID: <20111030171846.GD13286@tango.0pointer.de>
References: <1317943022.1095.25.camel@mop>
 <CALdu-PBLCNXTaZuODyzw_g_FQNyLqK_FsdObC=HjtEp75vkdFQ@mail.gmail.com>
 <20111019230347.GA32295@tango.0pointer.de>
 <CALdu-PCRj4+tL-6MXwsZKuODHRQn_pixdfVLwC6PV2a0q4sw4g@mail.gmail.com>
 <20111019233111.GE32295@tango.0pointer.de>
 <20111022102126.GA2811@somewhere.feld.cvut.cz>
 <20111022152841.GA1913@tango.0pointer.de>
 <4EA64BBE.1040807@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EA64BBE.1040807@cn.fujitsu.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25.10.11 13:40, Li Zefan (lizf@cn.fujitsu.com) wrote:

> > cgroups provides us with all of that, though the last two items only in
> > a suboptimal way: notification of cgroups running empty is ugly, since
> > it is done by spawning a usermode helper (we'd prefer a netlink msg or
> > so), and the process killing is a bit racy.
> 
> How about using eventfd? You can create an eventfd for the specific "tasks"
> file, and when the cgroup gets empty (no task in it), you'll get a notification.
> 
> It should be easy to implement, since cgroup already supports eventfd-based
> API.

I am quite convinced that using eventfd() like this is quite ugly. The
current evetnfd() logic is not recursive anyway, hence wouldn't help us
much.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
