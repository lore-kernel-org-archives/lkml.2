Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab1JVP2n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 11:28:43 -0400
Received: from tango.0pointer.de ([85.214.72.216]:38233 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab1JVP2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 11:28:42 -0400
Date: Sat, 22 Oct 2011 17:28:41 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Menage <paul@paulmenage.org>, Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel@vger.kernel.org, harald@redhat.com, david@fubar.dk,
        greg@kroah.com
Subject: Re: A =?utf-8?Q?Plumber=E2=80=99?=
	=?utf-8?Q?s?= Wish List for Linux
Message-ID: <20111022152841.GA1913@tango.0pointer.de>
References: <1317943022.1095.25.camel@mop>
 <CALdu-PBLCNXTaZuODyzw_g_FQNyLqK_FsdObC=HjtEp75vkdFQ@mail.gmail.com>
 <20111019230347.GA32295@tango.0pointer.de>
 <CALdu-PCRj4+tL-6MXwsZKuODHRQn_pixdfVLwC6PV2a0q4sw4g@mail.gmail.com>
 <20111019233111.GE32295@tango.0pointer.de>
 <20111022102126.GA2811@somewhere.feld.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111022102126.GA2811@somewhere.feld.cvut.cz>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22.10.11 12:21, Frederic Weisbecker (fweisbec@gmail.com) wrote:

> If you really need to stop any forks in a cgroup, then a cgroup core feature
> handling that very single purpose would be better and more efficient.

We'd be happy with that and this is what we originally suggested actually.

> That said I'm not really sure why you're using cgroups in Systemd.

We want to reliably label processes in a hierarchial way, so that this
is inherited by all child processes, cannot be overriden by unprivileged
code (subject to some classic Unix access control handling) and get
notifications when such a label stops referring to any process. We use
that for sticking the service name on a process, so that all CGI
processes of Apache are automatically assigned the same service as
apache itself. And we want a notification when all of apache's processes
die. And we also want to be able to kill Apache compeltely by killing
all its processes.

cgroups provides us with all of that, though the last two items only in
a suboptimal way: notification of cgroups running empty is ugly, since
it is done by spawning a usermode helper (we'd prefer a netlink msg or
so), and the process killing is a bit racy.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
