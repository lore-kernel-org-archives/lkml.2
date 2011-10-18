Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932547Ab1JRPV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 11:21:57 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:57154 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754412Ab1JRPV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 11:21:56 -0400
X-Sasl-enc: u3WjPpq9gW+pVXMqaTi58PrySPbs4wNlE+tFdG6ijDpC 1318951315
Date: Tue, 18 Oct 2011 08:21:33 -0700
From: Greg KH <greg@kroah.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel.org status: hints on how to check your machine for
 intrusion
Message-ID: <20111018152133.GA20411@kroah.com>
References: <4E8655CD.90107@zytor.com>
 <20110930235924.GA25176@kroah.com>
 <20111018171349.345f2a60@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111018171349.345f2a60@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 05:13:49PM +0200, Jean Delvare wrote:
> Hi Greg,
> 
> Yes I know I'm late, sorry about that.
> 
> On Fri, 30 Sep 2011 16:59:24 -0700, Greg KH wrote:
> >    b. Strange directories in /usr/share that do not belong to a package.
> >       This can be checked on an rpm system with the following bash snippet:
> > 	for file in `find /usr/share/`; do
> > 		package=`rpm -qf -- ${file} | grep "is not owned"`
> > 		if [ -n "$package" ] ; then
> > 			echo "weird file ${file}, please check this out"
> > 		fi
> > 	done
> 
> FWIW, the above doesn't work in the general case. For one thing it
> fails for files which have a space in their name. But a bigger problem
> is that rpm is localized so for any user running a non-English locale,
> the grep "is not owned" will not catch anything (in addition to being
> slow.) Better just check the value returned by rpm:
> 
> find /usr/share -print0 \
> | while read -d $'\0' -r file
> do
> 	if ! rpm -qf --quiet -- "${file}" ; then
> 		if [ -L "${file}" ] ; then
> 			type=link
> 		elif [ -d "${file}" ] ; then
> 			type=directory
> 		else
> 			type=file
> 		fi
> 
> 		echo "Weird ${type} ${file}, please check this out"
> 	fi
> done

Thanks for the updated script, you are right, it was localized for my
system.

> Even with this, I'm not convinced, due to the high number of false
> positives (generated cache files, directories not explicitly packaged,
> etc...) it is hard to make sense of the output.

Really?  I see almost none of that on my openSUSE boxes.

> We'd need to fix all
> the packages first so that only actual changes are returned by the
> script.
> 
> I'm also unsure why /usr/share would be a better target than any other
> system directory.

It's a very common place for rootkits to hide their files.

And they look pretty obvious when you see them, so they will not just
blend in with the other "normal" files you describe above.  So it's
still a good thing to run to check your system to help ensure that it is
clean.

thanks,

greg k-h
