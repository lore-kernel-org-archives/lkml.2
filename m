Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab1KAB0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 21:26:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52575 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751098Ab1KAB0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 21:26:10 -0400
Message-ID: <4EAF4B16.6030505@cn.fujitsu.com>
Date: Tue, 01 Nov 2011 09:27:50 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Lennart Poettering <mzxreary@0pointer.de>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Menage <paul@paulmenage.org>, Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel@vger.kernel.org, harald@redhat.com, david@fubar.dk,
        greg@kroah.com
Subject: Re: A =?windows-1252?Q?Plumber=92s_Wish_List_for_Linux?=
References: <1317943022.1095.25.camel@mop> <CALdu-PBLCNXTaZuODyzw_g_FQNyLqK_FsdObC=HjtEp75vkdFQ@mail.gmail.com> <20111019230347.GA32295@tango.0pointer.de> <CALdu-PCRj4+tL-6MXwsZKuODHRQn_pixdfVLwC6PV2a0q4sw4g@mail.gmail.com> <20111019233111.GE32295@tango.0pointer.de> <20111022102126.GA2811@somewhere.feld.cvut.cz> <20111022152841.GA1913@tango.0pointer.de> <4EA64BBE.1040807@cn.fujitsu.com> <20111030171846.GD13286@tango.0pointer.de>
In-Reply-To: <20111030171846.GD13286@tango.0pointer.de>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-01 09:26:15,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-01 09:26:16,
	Serialize complete at 2011-11-01 09:26:16
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=windows-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Poettering wrote:
> On Tue, 25.10.11 13:40, Li Zefan (lizf@cn.fujitsu.com) wrote:
> 
>>> cgroups provides us with all of that, though the last two items only in
>>> a suboptimal way: notification of cgroups running empty is ugly, since
>>> it is done by spawning a usermode helper (we'd prefer a netlink msg or
>>> so), and the process killing is a bit racy.
>>
>> How about using eventfd? You can create an eventfd for the specific "tasks"
>> file, and when the cgroup gets empty (no task in it), you'll get a notification.
>>
>> It should be easy to implement, since cgroup already supports eventfd-based
>> API.
> 
> I am quite convinced that using eventfd() like this is quite ugly. The
> current evetnfd() logic is not recursive anyway, hence wouldn't help us
> much.
> 

I remember in an earlier email you stated you want to be able to kill all tasks
in a cgroup and its children, and you used the word "recursive", but what do you
mean by ""recursive" for empty cgroup notification, do you expect the listener
to recieve a message if a cgroup or any of its children becomes empty?
