Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759187Ab0J1Pop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 11:44:45 -0400
Received: from rt-pi1-ru-sssup.pi1.garr.net ([193.206.136.46]:57240 "EHLO
	sssup.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754786Ab0J1Pol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 11:44:41 -0400
Message-ID: <4CC99A65.9050706@sssup.it>
Date: Thu, 28 Oct 2010 17:44:37 +0200
From: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.11) Gecko/20101006 Thunderbird/3.1.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Peter Zijlstra <peterz@infradead.org>,
        Dhaval Giani <dhaval.giani@gmail.com>, Paul Menage <menage@google.com>
Subject: Understanding cgroups
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to get some understanding of the current cgroups in-kernel 
implementation
(after having read Documentation/cgroup* and having browsed a bit the code).
To this purpose, I tried to draw the relationships among the involved 
data structures
(I'm limited to its relationship with [real-time] scheduling), and 
obtained this:

   http://retis.sssup.it/~tommaso/cgroups.odg
   http://retis.sssup.it/~tommaso/cgroups.eps

(You can see in the bottom left part of the diagram a little 
"key/legend/pattern" for representing lists).

I might have done mistakes, however the greatest doubts that I have now 
concern the relative
cardinalities of the various associated items. Namely:
a) why doesn't a cgroup object directly point to a css_set one, but to a 
list of them (via cg_cgroup_list elements) ?
     it seems that a cgroup object may be associated to multiple css_set 
objects, which in turn contain vectors of
     cgroup_subsys_state;
b) however, cgroup.subsys[] would point to a single cgroup_subsys_state 
object per subsys_id, so, what is the
     difference between cgroup.subsys[] and css_set.subsys[] ? (or, are 
these all redundant pointers and point
     to the same cgroup_subsys_state objects ?)
c) is css_set.cg_links used to point to (the head of) a list of 
cg_cgroup_link objects, or is it used to link multiple css_set objects 
into a list ? In the latter case, where is the head of the list pointed 
to from ?

Apologies for the newbie questions that I might have posted; FYI, I'm 
trying to set-up RT scheduling groups without using the VFS-based 
cgroups interface.

Thanks in advance, regards (please, reply in cc to my e-mail address).

     Tommaso

-- 
Tommaso Cucinotta, Computer Engineering PhD, Researcher
ReTiS Lab, Scuola Superiore Sant'Anna, Pisa, Italy
Tel +39 050 882 024, Fax +39 050 882 003
http://retis.sssup.it/people/tommaso

