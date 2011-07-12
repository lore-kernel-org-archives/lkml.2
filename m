Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab1GLFxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 01:53:33 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46253 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148Ab1GLFxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 01:53:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAJfuBxxvDhRgwfosZHZEAsgeLsAzDigHh-j3mC+8aJByR-=GkQ@mail.gmail.com>
References: <CAJfuBxyhh=3rO9MLkfDic16mij4A6NLXEQnhsvHEmBKokMoF7A@mail.gmail.com>
 <CAO+b5-rP8JAqe5pV7x_4RR5aumpHi4JG5diHehe5BiS_QwzSvw@mail.gmail.com> <CAJfuBxxvDhRgwfosZHZEAsgeLsAzDigHh-j3mC+8aJByR-=GkQ@mail.gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 12 Jul 2011 07:53:11 +0200
X-Google-Sender-Auth: EO-1TlY7SssdZf26yklGL1OCvng
Message-ID: <CAO+b5-pZPsbnpjnFzCQFxWrAtoeG71pn1wVqjcOrR9yBQ3L1nA@mail.gmail.com>
Subject: Re: [ patch 00/21 ] support multiple, pending ddebugs at kernel-boot
To: Jim Cromie <jim.cromie@gmail.com>
Cc: jbaron@redhat.com, linux-kernel@vger.kernel.org, joe@perches.com,
        gregkh@suse.de, gnb@fmeh.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 9:06 PM, Jim Cromie <jim.cromie@gmail.com> wrote:
> On Mon, Jul 11, 2011 at 12:30 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>> As far as I can see with v2 of this patch set a query gets on the
>> pending list if either +a has been specified or no matches were found
>> the first time a query is run. Are both mechanisms necessary ? If not,
>> I propose to leave out the second. That will not only allow to
>> simplify the code somewhat but will also reduce confusion for
>> dynamic_printk users.
>>
>
> Both conditions are necessary:
> - 'a' flag required,
> - query not directly applicable.
>
> root@voyage:~# echo "module nosuch +p" > /dbg/dynamic_debug/control
> root@voyage:~# cat /sys/module/dynamic_debug/parameters/pending_ct
> 0
>
> root@voyage:~# echo "module nosuch +ap" > /dbg/dynamic_debug/control
> root@voyage:~# cat /sys/module/dynamic_debug/parameters/pending_ct
> 1

The above example contradicts the following code added in patch 09/21:

 	/* actually go and implement the change */
 	nfound = ddebug_change(&query, flags, mask);
+
+	pr_info("nfound %d on %s\n", nfound, show_ddebug_query(&query));
+	if (!nfound)
+		return ddebug_save_pending(&query, flags, mask);
+
 	return 0;

Bart.
