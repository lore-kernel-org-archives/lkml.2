Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932912Ab2IDXRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 19:17:34 -0400
Received: from mga10.intel.com ([192.55.52.92]:45987 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932877Ab2IDXRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 19:17:33 -0400
MIME-Version: 1.0
In-Reply-To: <19214.1346799098@warthog.procyon.org.uk>
References: <20120816013405.872.42381.stgit@warthog.procyon.org.uk>
	<87627ufi2h.fsf@rustcorp.com.au>
	<CAKi4VALezG7VccXJfwvzr2UZrmAjCUp9eZRjGwqq6cWcExNqXA@mail.gmail.com>
	<19214.1346799098@warthog.procyon.org.uk>
Date: Wed, 5 Sep 2012 02:17:31 +0300
Message-ID: <CALLzPKZcaTBjLaPY33aVTWekpn_b4qng1fFSab=azu1EgO_ysA@mail.gmail.com>
Subject: Re: [RFC] module: signature infrastructure
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: David Howells <dhowells@redhat.com>
Cc: Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>, zohar@linux.vnet.ibm.com,
        jmorris@namei.org, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 5, 2012 at 1:51 AM, David Howells <dhowells@redhat.com> wrote:
> Lucas De Marchi <lucas.de.marchi@gmail.com> wrote:
>
>> Or let the magic string as the last thing in the module and store the
>> signature length, too. In this case no scanning is needed
>
> Indeed.  This is the better way.
>
> The main problem is rendering the length from a shell script.  It's trivial to
> do as ASCII (there's a printf program), but a pain to render to binary.  I'm
> sure it can be done with perl or python without the need to compile anything.
>
> David

That is very easy to do from script as well.
See script in my tree.

http://git.kernel.org/?p=linux/kernel/git/kasatkin/linux-digsig.git;a=blob;f=scripts/modsig.sh;h=4e997c3996d71d8e1afeb3a7afe23b3f303b9f63;hb=59f1d5352969166f2f32f84e07e20dd1b30a890f

110 # add signature length - big endian
111 dec2hex $(stat --printf %s $sigfile) 4 | hex2bin $sigfile
112 echo -n "This Is A Crypto Signed Module" >>$sigfile

well. I have couple of small functions in the script. dec2hex and hex2bin

- Dmitry
