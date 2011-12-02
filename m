Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab1LBOZy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 09:25:54 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:41400 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865Ab1LBOZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 09:25:53 -0500
From: Pedro Alves <pedro@codesourcery.com>
Organization: CodeSourcery
To: Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [rfc 2/3] fs, proc: Introduce the Children: line in /proc/<pid>/status
Date: Fri, 2 Dec 2011 14:25:44 +0000
User-Agent: KMail/1.13.6 (Linux/2.6.38-13-generic; KDE/4.7.2; x86_64; ; )
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Vasiliy Kulikov <segoon@openwall.com>
References: <20111129191252.769160532@openvz.org> <201112021400.42762.pedro@codesourcery.com> <4ED8DDE4.8040609@parallels.com>
In-Reply-To: <4ED8DDE4.8040609@parallels.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112021425.44897.pedro@codesourcery.com>
X-OriginalArrivalTime: 02 Dec 2011 14:25:47.0247 (UTC) FILETIME=[488FD7F0:01CCB0FE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 December 2011 14:17:08, Pavel Emelyanov wrote:

> O_O   OK, I was wrong, they do live there. But I consider this as bug.

You can't change that.  It'd break current gdb at least.

> Anyway -- my concern about unneeded memory overhead still stands.
> Even a simple find /proc will result in smth like
> 
> /proc/1
> /proc/1/children/2
> /proc/1/children/2/children/4
> /proc/1/children/2/children/4
> /proc/1/children/3
> /proc/1/children/3/children/5
> /proc/2
> /proc/2/children/4
> /proc/3
> /proc/3/children/5
> /proc/4
> /proc/5
> 
> Instead of
> 
> /proc/1
> /proc/2
> /proc/3
> /proc/4
> /proc/5
> 
> I.e. each task will be shown multiple times, which is not very fun, but memory exhaustive from my POV.

Now that is a good argument against hard linking.  But not if you make
the entries under children/ symlinks.  Then find doesn't recurse.  And
then 

$ find -L /proc/PID/

does recurse and give you the whole tree.  Which I'd say is
actually useful...

-- 
Pedro Alves
