Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab2BHOCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 09:02:32 -0500
Received: from mga05.intel.com ([192.55.52.89]:37888 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751538Ab2BHOCa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 09:02:30 -0500
MIME-Version: 1.0
In-Reply-To: <1328708710.2679.4.camel@falcor>
References: <cover.1328122362.git.dmitry.kasatkin@intel.com>
	<alpine.LRH.2.00.1202061250400.16907@tundra.namei.org>
	<CALLzPKZSWSp6r-5e1c1Z6qOH6C0DcOz=LHJ20Y468SQE6UU1ww@mail.gmail.com>
	<87zkcuh8iq.fsf@rustcorp.com.au>
	<CALLzPKZRUTaOE8afXD1b=Kd6fOaisOpAW+XGJMi7uHdE0sEgFw@mail.gmail.com>
	<87bopagqn4.fsf@rustcorp.com.au>
	<1328708710.2679.4.camel@falcor>
Date: Wed, 8 Feb 2012 16:02:28 +0200
Message-ID: <CALLzPKb=6hSAW0-QxEhkH8wih8c20cLqcLVjm+CcXBGp0a901Q@mail.gmail.com>
Subject: Re: [RFC][PATCH v1 0/2] integrity: module integrity verification
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@ozlabs.org>, James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Jon Masters <jcm@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 8, 2012 at 3:45 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> On Wed, 2012-02-08 at 10:09 +1030, Rusty Russell wrote:
>> On Tue, 7 Feb 2012 23:18:38 +0200, "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com> wrote:
>> > On Tue, Feb 7, 2012 at 7:13 PM, Rusty Russell <rusty@ozlabs.org> wrote:
>> > > On Mon, 6 Feb 2012 08:59:00 +0200, "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com> wrote:
>> > >> On Mon, Feb 6, 2012 at 3:51 AM, James Morris <jmorris@namei.org> wrote:
>> > >> > On Wed, 1 Feb 2012, Dmitry Kasatkin wrote:
>> > >> >
>> > >> >> Hi,
>> > >> >>
>> > >> >> Here is another module verification patchset, which is based on the recently
>> > >> >> upstreamed digital signature support used by EVM and IMA-appraisal.
>> > >> >
>> > >> > You should cc: Rusty on any changes to the module code.
>> > >> >
>> > >>
>> > >> Hello,
>> > >>
>> > >> Mimi already has pointed that out.
>> > >> I have sent him an email with the link..
>> > >
>> > > Thanks.
>> > >
>> > > Using an external signature (via cmdline arguments) is simple, at
>> > > least.  Not sure what the userspace side of this looks like?
>> > >
>> >
>> > Hello,
>> >
>> > There are couple of patches for modprobe and insmod...
>> >
>> > You could see them on the top at:
>> > http://linux-ima.git.sourceforge.net/git/gitweb.cgi?p=linux-ima/module-init-tools.git;a=summary
>> >
>> > It first tries to read signature from xattr, then from file...
>> > "modprobe -v" will show 'ima='  parameter with signature.
>> >
>> > - Dmitry
>>
>> The problem is that distributions tend to have two variants of modules:
>> stripped and unstripped.  Thus you may want to support multiple
>> signatures, any *one* of which may match.
>>
>> I've cc'd the module-init-tools and libkmod maintainers for their
>> comments, too.
>>
>> Cheers,
>> Rusty.
>
> Hi Rusty,
>
> As a distro knows what it is shipping, why would you need support for
> both stripped/unstripped versions.  Unless "stripping" occurs post
> install.  Perhaps something similar to 'prelink'?
>

How are they distributed? In separate packages?
And striped during package creation?
Then during package building, before archiving, signing tool is simply
invoked for each binary package,
so "same" modules from different packages will get own signature.

Or it goes some other way?

> thanks,
>
> Mimi
>
