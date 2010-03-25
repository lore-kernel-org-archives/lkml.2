Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab0CYAbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 20:31:36 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:44318 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab0CYAbf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 20:31:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=JbugH6AHyICp2bnwWZBhuVgplrtGi1heCwdHalGFQe82xLOW/hdQwbWa2WVu+/fNtm
         6j/tth+32Q2FlikCZIAdNQM5ojEojNLThLXSxzu7iR6E3zKDN7DSJQ8QIsIvAuOuK0sP
         kQX7X+aDSZbigDlJTHKtNH1PqBnPhRYZGV7LY=
MIME-Version: 1.0
In-Reply-To: <1269476692.2957.3267.camel@gandalf.stny.rr.com>
References: <1269473050-11413-1-git-send-email-jkacur@redhat.com>
	 <1269473050-11413-6-git-send-email-jkacur@redhat.com>
	 <1269476692.2957.3267.camel@gandalf.stny.rr.com>
Date: Thu, 25 Mar 2010 01:31:32 +0100
X-Google-Sender-Auth: c3dc71db2bf2bd5f
Message-ID: <520f0cf11003241731r129590a1ha0bf28312659e87f@mail.gmail.com>
Subject: Re: [PATCH 5/5] trace-cmd: Simplify Makefile, and remove confusing 
	messages.
From: John Kacur <jkacur@redhat.com>
To: rostedt@goodmis.org
Cc: lkml <linux-kernel@vger.kernel.org>, Darren Hart <dvhltc@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 1:24 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 2010-03-25 at 00:24 +0100, John Kacur wrote:
>> During the make process the user is told many times
>> *** to install the gui, type "make install gui" ***
>> This is confusing for many reasons.
>> 1. "***" are output when Make encounters errors, so the messages look like errors
>> 2. Why do we need to be told that if we are not interested in the gui?
>
> I'm fine with all the patches but this one. Maybe it's a matter of
> opinion, but one thing that I've learned is to make things easy for
> users. I point people to this repo for kernelshark. If they do make, and
> don't get it, I want them to know that they can do in with make gui, and
> not expect them to have to look at other files. Yes I consider people
> lazy.
>
> Maybe this is OK, but I would like to hear other opinions on this
> subject. A README and INSTALL maybe fine instead.

If you don't like this, I could just submit the README changes
but I would at least recommend that we change the messages
so they don't like like Makefile errors.

For example: REMINDER: You can make the gui by typing make gui
instead of the *** that match make file errors.

>
> Thanks,
>
> -- Steve
>
>>
>> Remove these kinds of messages, and simplify the Makefile.
>> However, in order to replace this information, add to the README with a
>> BUILDING and INSTALL section
>>
>> Signed-off-by: John Kacur <jkacur@redhat.com>
>> ---
>>  Makefile |   19 ++++---------------
>>  README   |   26 ++++++++++++++++++++++++++
>>  2 files changed, 30 insertions(+), 15 deletions(-)
>>
>> diff --git a/Makefile b/Makefile
>> index 8a3f25c..15f2ffa 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -241,14 +241,14 @@ TARGETS = $(CMD_TARGETS) $(GUI_TARGETS)
>>  #    If you want kernelshark, then do:  make gui
>>  ###
>>
>> -all: all_cmd show_gui_make
>> +all: all_cmd
>>
>>  all_cmd: $(CMD_TARGETS)
>>
>>  gui: $(CMD_TARGETS)
>>       $(Q)$(MAKE) -f $(src)/Makefile BUILDGUI=1 all_gui
>>
>> -all_gui: $(GUI_TARGETS) show_gui_done
>> +all_gui: $(GUI_TARGETS)
>>
>>  GUI_OBJS = $(KERNEL_SHARK_OBJS) $(TRACE_VIEW_MAIN_OBJS) $(TRACE_GRAPH_MAIN_OBJS)
>>
>> @@ -372,14 +372,6 @@ ifneq ($(dep_includes),)
>>   include $(dep_includes)
>>  endif
>>
>> -show_gui_make:
>> -     @echo "*** to build the gui, type \"make gui\" ***"
>> -
>> -show_gui_done:
>> -     @echo "*** gui build complete ***"
>> -
>> -PHONY += show_gui_make
>> -
>>  tags:        force
>>       $(RM) tags
>>       find . -name '*.[ch]' | xargs ctags
>> @@ -392,14 +384,11 @@ install_plugins: $(PLUGINS)
>>       $(INSTALL) -d -m 755  '$(plugin_dir_SQ)'
>>       $(INSTALL) $^  '$(plugin_dir_SQ)'
>>
>> -install_cmd: all_cmd install_plugins
>> +install: all_cmd install_plugins
>>       $(INSTALL) -d -m 755 '$(bindir_SQ)'
>>       $(INSTALL) trace-cmd '$(bindir_SQ)'
>>
>> -install: install_cmd
>> -     @echo "*** to install the gui, type \"make install_gui\" ***"
>> -
>> -install_gui: install_cmd gui
>> +install_gui: install gui
>>       $(INSTALL) -d -m 755 '$(bindir_SQ)'
>>       $(INSTALL) trace-view '$(bindir_SQ)'
>>       $(INSTALL) trace-graph '$(bindir_SQ)'
>> diff --git a/README b/README
>> index 7ac4390..d191197 100644
>> --- a/README
>> +++ b/README
>> @@ -9,3 +9,29 @@ These files also make up the code to create the libraries
>>  The applications are licensed under the GNU General Public License 2.0
>>  (see COPYING) and the libraries are licensed under the GNU
>>  Lesser General Public License 2.1 (See COPYING.LIB).
>> +
>> +BUILDING:
>> +
>> +To make trace-cmd
>> +    make
>> +
>> +To make the gui
>> +    make gui
>> +
>> +INSTALL:
>> +
>> +To install trace-cmd
>> +    make install
>> +
>> +To install the gui
>> +    make install_gui
>> +
>> +Note: The default install is relative to /usr/local
>> +    The default install directory is /usr/local/bin
>> +    The default plugin directory is /usr/local/share/trace-cmd/plugins
>> +
>> +To change the default, you can set 'prefix', eg
>> +mkdir $HOME/test-trace
>> +make prefix=$HOME/test-trace
>> +make prefix=$HOME/test-trace install
>> +
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
