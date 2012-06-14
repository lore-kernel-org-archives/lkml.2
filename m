Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554Ab2FNUdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 16:33:12 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59201 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756449Ab2FNUdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 16:33:09 -0400
MIME-Version: 1.0
In-Reply-To: <1339701783.5981.5.camel@x61.thuisdomein>
References: <20120612105913.GA8404@aftab.osrc.amd.com> <1339699862-3731-1-git-send-email-jim.cromie@gmail.com>
 <1339701783.5981.5.camel@x61.thuisdomein>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Thu, 14 Jun 2012 14:32:38 -0600
Message-ID: <CAJfuBxxBD5eiMMTW5+q6LEpv+WLcbcsxxY6eEjbaTVCFqBeKmA@mail.gmail.com>
Subject: Re: [PATCH] init: add comments to keep initcall-names in sync with
 initcall levels
To: Paul Bolle <pebolle@tiscali.nl>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, bp@amd64.org,
        pawel.moll@arm.com, jbaron@redhat.com, gregkh@linuxfoundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 1:23 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Thu, 2012-06-14 at 12:51 -0600, Jim Cromie wrote:


>>   *
>>   * This only exists for built-in code, not for modules.
>> + * Keep main.c:initcall_level_names[] in sync. */
>>   */

> This comment now ends with "*/" twice. Perhaps that's legal (I haven't
> even bothered to check) but it is really too ugly.

Guilty as charged, revision forthcoming.


>>
>> -/* Don't use these in modules, but some people do... */
>> +/* Don't use these in loadable modules, but some people do... */
>
> What problem does this solve?
>


kernel/params.c  and other builtins are also modules - at least wrt
how theyre reported by dynamic_debug:

kernel/params.c:121 [params]parse_one =_ "Unknown argument `%s'\012"
kernel/params.c:117 [params]parse_one =_ "Unknown argument: calling %p\012"
kernel/params.c:108 [params]parse_one =_ "They are equal!  Calling %p\012"
kernel/params.c:188 [params]parse_args =_ "Parsing ARGS: %s\012"

The advice to avoid those macros does not apply to builtin "modules"
