Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190Ab1GKSar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 14:30:47 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:47636 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758084Ab1GKSap convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 14:30:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAJfuBxyhh=3rO9MLkfDic16mij4A6NLXEQnhsvHEmBKokMoF7A@mail.gmail.com>
References: <CAJfuBxyhh=3rO9MLkfDic16mij4A6NLXEQnhsvHEmBKokMoF7A@mail.gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 11 Jul 2011 20:30:25 +0200
X-Google-Sender-Auth: -t0GUvDt8i5WRFWtWzt_Gg40LjI
Message-ID: <CAO+b5-rP8JAqe5pV7x_4RR5aumpHi4JG5diHehe5BiS_QwzSvw@mail.gmail.com>
Subject: Re: [ patch 00/21 ] support multiple, pending ddebugs at kernel-boot
To: Jim Cromie <jim.cromie@gmail.com>
Cc: jbaron@redhat.com, linux-kernel@vger.kernel.org, joe@perches.com,
        gregkh@suse.de, gnb@fmeh.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 5:21 PM, Jim Cromie <jim.cromie@gmail.com> wrote:
> On Mon, Jul 11, 2011 at 1:46 AM, Jim Cromie <jim.cromie@gmail.com> wrote:
>>
>> This patchset extends dynamic-debug facility to allow
>> use of pr_debug() within a loadable module's module_init()
>> function.  Query/rules can be given on the boot-line,
>> and are saved to a pending list if they cannot be applied
>> immediately.  Later, when the module is being loaded, the
>> pending list is scanned, and matching rules are applied.
>> Thus pr_debug() calls in the module's initialization function
>> are active when it is invoked.
>>
>>
>> Changes since rev1:
>>
>> - rebased on top of Jasons & Joes patchset
>> - fixed accidental unescape removal, noted by Bart
>> - trim src-path patch checks for matching prefix before trimming
>>  should now work for out-of-tree modules.
>> - undid verbose newline-strip in exec-queries - Bart
>> - verbose param 644, not 744 - Bart, Greg
>> - whitespace - Bart
>> - added 'a' flag - Jason, Bart
>> - drop pending_max - Bart

As far as I can see with v2 of this patch set a query gets on the
pending list if either +a has been specified or no matches were found
the first time a query is run. Are both mechanisms necessary ? If not,
I propose to leave out the second. That will not only allow to
simplify the code somewhat but will also reduce confusion for
dynamic_printk users.

Bart.
