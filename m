Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab2FPHuj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 03:50:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54173 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab2FPHuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 03:50:37 -0400
MIME-Version: 1.0
In-Reply-To: <20120615143403.GA18876@localhost>
References: <20120614172523.GB4400@mwanda>
	<20120615014835.GA5695@localhost>
	<20120615071222.GZ13539@mwanda>
	<20120615075810.GA13206@localhost>
	<alpine.DEB.2.02.1206150639130.1864@hadrien>
	<20120615111913.GA13539@mwanda>
	<20120615143403.GA18876@localhost>
Date: Sat, 16 Jun 2012 15:50:36 +0800
Message-ID: <CAM_iQpUPYpYVaZhCk-bfMe9ZvttQYaSYM_xfKJYX=Z494PWv+A@mail.gmail.com>
Subject: Re: automated warning notifications
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Fengguang Wu <wfg@linux.intel.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Julia Lawall <julia.lawall@lip6.fr>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Christopher Li <sparse@chrisli.org>,
        Josh Triplett <josh@freedesktop.org>,
        Linus Torvalds <torvalds@ppc970.osdl.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 10:34 PM, Fengguang Wu <wfg@linux.intel.com> wrote:
> On Fri, Jun 15, 2012 at 02:19:14PM +0300, Dan Carpenter wrote:
>>
>> Probably we could use something like the attached script to print
>> out the line of code which causes the bug and some other script to
>> querry git blame and attach the offending commit?
>
> cat -n $code_file | tail -n +$(($lineno - (($context + 1) / 2))) | head -n $(($context + 1))
>
> That's handy, I'll use it to show the source file context for the
> first error/warning :-)

Well, you can use sed/awk, it will be much shorter:

cat -n drivers/leds/led-triggers.c | sed -ne '224,230p'
   224			struct led_classdev *led_cdev;
   225	
   226			led_cdev = list_entry(entry, struct led_classdev, trig_list);
   227			led_set_brightness(led_cdev, brightness);
   228		}
   229		read_unlock(&trigger->leddev_list_lock);
   230	}

(replace the hard-coded "224,230" with a shell variable)

And if you want to find the offending commit:

git show `git blame drivers/leds/led-triggers.c | awk 'NR==227{print $1}'`
