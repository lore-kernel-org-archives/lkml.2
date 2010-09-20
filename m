Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879Ab0ITVxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 17:53:42 -0400
Received: from ist.d-labs.de ([213.239.218.44]:60264 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529Ab0ITVxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 17:53:41 -0400
Date: Mon, 20 Sep 2010 23:53:37 +0200
From: Florian Mickler <florian@mickler.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>, Greg KH <greg@kroah.com>
Subject: Re: [RFC PATCH] scripts/get_maintainer.pl: add interactive mode
Message-ID: <20100920235337.6e0ac989@schatten.dmk.lab>
In-Reply-To: <1285011788.25988.48.camel@Joe-Laptop>
References: <1284558207-10223-1-git-send-email-florian@mickler.org>
	<1284563819-11363-1-git-send-email-florian@mickler.org>
	<1285011788.25988.48.camel@Joe-Laptop>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Sep 2010 12:43:08 -0700
Joe Perches <joe@perches.com> wrote:

> On Wed, 2010-09-15 at 17:16 +0200, florian@mickler.org wrote:
> > This is a first version of an interactive mode for
> > scripts/get_maintainer.pl .
> 
> Thank you Flo.
> 
> I've used Flo's initial patch and created a rather more
> complete version now built on top of mm with the 5
> get_maintainer patches posted earlier.
> 
> http://lkml.org/lkml/2010/9/16/150

Hi Joe!

Thx for wrapping this up. 

> 
> Flo and I have worked together on this and he has some
> upcoming enhancements that could improve the rerun
> speed quite a bit.
> 
> For now, this uses whatever command line options are
> passed as well as allows the user to change these
> settings from a prompt during use.
> 
> There are still defects in this version.
> 
> You can see below that Stephen Hemminger's sign-offs
> aren't correctly attributed because his MAINTAINER
> entry doesn't match how he normally signs-off
> (ie: @vyatta.com vs @linux-foundation.org)

I pondered quite a bit about how to tell developers apart. Here is how
it should work:

It is common for developers to commit via different mailaddresses,
while it is uncommon for two distinct developers to have the same name. 

So the only workable solution is to tell developers apart by their real
name (the name part of an Emailaddress of the form Jane Doe
<j.d@example.com> ).

Then the .mailmap also makes sense. :) 

If a new developer commits and his name clashes with some other
developer, the .mailmap has to be set up to attach a somewhat distinct
name to his commit-mailaddresses.  (I.e. another "Jane Doe" has to
have a .mailmap entry that map's her email-address to "Jane F. Doe" or
"Jane Doe 2" or whatever she prefers.)


 
> For example, the --interactive (or -i) menu looks like:
> 
> --------------------------------------------------------------------------------
> $ ./scripts/get_maintainer.pl -i -f drivers/net/sky2.c
> 
> *  # email/list and role:stats                                        auth sign
> *  1 Stephen Hemminger <shemminger@linux-foundation.org>              
>      maintainer:SKGE, SKY2 10/100...
> *  2 netdev@vger.kernel.org                                           
>      open list:SKGE, SKY2 10/100...
> *  3 linux-kernel@vger.kernel.org                                     
>      open list
> 
> #(toggle), A#(author), S#(signed) *(all), ^(none), O(options), Y(approve): 
> --------------------------------------------------------------------------------


I don't think the descriptions on the bottom are that descriptive. Nor
can they be. There should probably be just a quick primer like:

"([N]+:select) ([N]-:deselect) ([N]?:toggle infos) (Y:approve) (h:help)"

and on "h" a long description gets displayed.

> 
> with options:
> 
> Version Control options:
> g  use git history      [0]
> gf use git-fallback     [1]
> b  use git blame        [0]
> bs use blame signatures [1]
> c# minimum commits      [1]
> %# min percent          [5]
> d# history to use       [1-year-ago]
> x# max maintainers      [5]
> t  all signature types  [0]

good idea to let the user fumble with the options

> 
> Additional options:
> 0  toggle all
> f  emails in file       [0]
> k  keywords in file     [1]
> r  remove duplicates    [1]
> p# pattern match depth  [0]
> 
> Because git history is now not searched by default
> when there is a named maintainer, there are no
> commit signers.

Don't know if this is intuitive. If there is the possibility to have
them shown but not selected, that would be ideal as it relieves the
user from pressing extra keys while still having a sane behaviour.

> 
> If the "G" option is entered, you get:
> 
> #(toggle), A#(author), S#(signed) *(all), ^(none), O(options), Y(approve): g
> --------------------------------------------------------------------------------
> *  # email/list and role:stats                                        auth sign
> *  1 Stephen Hemminger <shemminger@linux-foundation.org>                 1    0
>      maintainer:SKGE, SKY2 10/100...,commit_signer:38/69=55%
>    2 "David S. Miller" <davem@davemloft.net>                             7   57
>      commit_signer:57/69=83%
>    3 Mike McCormack <mikem@ring3k.org>                                  16   16
>      commit_signer:16/69=23%
>    4 Joe Perches <joe@perches.com>                                       4    4
>      commit_signer:4/69=6%
> *  5 netdev@vger.kernel.org                                           
>      open list:SKGE, SKY2 10/100...
> *  6 linux-kernel@vger.kernel.org                                     
>      open list

I would try to fit reviewed-by in the statistics on the right, because
that actually says a bit about the ability and willingness to review
code... 

 
> #(toggle), A#(author), S#(signed) *(all), ^(none), O(options), Y(approve): 
> --------------------------------------------------------------------------------
> 
> git signers are not selected by default, these can be selected either
> individually by #, or all by *, or multiple can be selected/deselected
> from a single command like: "2,3"

I would just use a simple menu command-format (like I did in the patch I
sent you) with the following parts:
 
	o the number  (optionally, when ommitted takes effect for all
		menu items)
	o a '+'(select) or '-' (deselect) sign (optionally, when
		omitted, defaults to toggle action)
	o one of A(show authored commits) or S(show sob-commits)
	(optionally, when omitted, selects/deselects the menu item for
	stdout)

 
> To see what commits any individual contributor has authored or
> signed, enter "A" or "S" with the #(s)
> 
> --------------------------------------------------------------------------------
> #(toggle), A#(author), S#(signed) *(all), ^(none), O(options), Y(approve): a4
> 
> *  # email/list and role:stats                                        auth sign
> *  1 Stephen Hemminger <shemminger@linux-foundation.org>                 1    0
>      maintainer:SKGE, SKY2 10/100...,commit_signer:38/69=55%
>    2 "David S. Miller" <davem@davemloft.net>                             7   57
>      commit_signer:57/69=83%
>    3 Mike McCormack <mikem@ring3k.org>                                  16   16
>      commit_signer:16/69=23%
>    4 Joe Perches <joe@perches.com>                                       4    4
>      commit_signer:4/69=6%
>      Author: drivers/net/sky2.c: Use (pr|netdev)_<level> macro helpers
>      Author: drivers/net/sky2: Convert to use netif_printk macros
>      Author: drivers/net: Move && and || to end of previous line
>      Author: trivial: remove unnecessary semicolons
> *  5 netdev@vger.kernel.org                                           
>      open list:SKGE, SKY2 10/100...
> *  6 linux-kernel@vger.kernel.org                                     
>      open list
> 
> #(toggle), A#(author), S#(signed) *(all), ^(none), O(options), Y(approve): 
> --------------------------------------------------------------------------------
> 
> There are also significant improvements in HG runtime.
> HG is now faster than git for blame and commit signer
> lookups.

nice. :) 
 
I  
> -    my %hash;
> -    my $exact_pattern_match = 0;
> -    my $tvi = find_first_section();
> -    while ($tvi < @typevalue) {
> -	my $start = find_starting_index($tvi);
> -	my $end = find_ending_index($tvi);
> -	my $exclude = 0;
> -	my $i;
> -
> -	#Do not match excluded file patterns
> -
> -	for ($i = $start; $i < $end; $i++) {
> -	    my $line = $typevalue[$i];
> -	    if ($line =~ m/^(\C):\s*(.*)/) {
> -		my $type = $1;
> -		my $value = $2;
> -		if ($type eq 'X') {
> -		    if (file_match_pattern($file, $value)) {
> -			$exclude = 1;
> -			last;
> -		    }
> -		}
> -	    }
> -	}

Yes, most of the global code should just land in nicely named
functions. [ Else nobody knows what it does :-) ]

> +sub interactive_get_maintainer {
> +    my ($list_ref) = @_;
> +    my @list = @$list_ref;
> +
> +    vcs_exists();
> +
> +    my %selected;
> +    my %authored;
> +    my %signed;
> +    my $count = 0;
> +
> +    #select maintainers by default
> +    foreach my $entry (@list){
> +	my $role = $entry->[1];
> +	$selected{$count} = ($role =~ /^(maintainer|supporter|open list)/);
> +	$authored{$count} = 0;
> +	$signed{$count} = 0;
> +	$count++;
> +    }
> +
> +    #menu loop
> +    my $done = 0;
> +    my $print_options = 0;
> +    my $redraw = 1;
> +    while (!$done) {
> +	$count = 0;
> +	if ($redraw) {
> +	    printf STDERR "\n%1s %2s %-65sauth sign\n",
> +		"*", "#", "email/list and role:stats";
> +	    foreach my $entry (@list) {
> +		my $email = $entry->[0];
> +		my $role = $entry->[1];
> +		my $sel = "";
> +		$sel = "*" if ($selected{$count});
> +		my $commit_author = $commit_author_hash{$email};
> +		my $commit_signer = $commit_signer_hash{$email};
> +		my $authored = 0;
> +		my $signed = 0;
> +		$authored++ for (@{$commit_author});
> +		$signed++ for (@{$commit_signer});
> +		printf STDERR "%1s %2d %-65s", $sel, $count + 1, $email;
> +		printf STDERR "%4d %4d", $authored, $signed
> +		    if ($authored > 0 || $signed > 0);
> +		printf STDERR "\n     %s\n", $role;
> +		if ($authored{$count}) {
> +		    my $commit_author = $commit_author_hash{$email};
> +		    foreach my $ref (@{$commit_author}) {
> +			print STDERR "     Author: @{$ref}[1]\n";
> +		    }
> +		}
> +		if ($signed{$count}) {
> +		    my $commit_signer = $commit_signer_hash{$email};
> +		    foreach my $ref (@{$commit_signer}) {
> +			print STDERR "     @{$ref}[2]: @{$ref}[1]\n";
> +		    }
> +		}
> +
> +		$count++;
> +	    }
> +	}
> +	my $date_ref = \$email_git_since;
> +	$date_ref = \$email_hg_since if (vcs_is_hg());
> +	if ($print_options) {
> +	    $print_options = 0;
> +	    if (vcs_exists()) {
> +		print STDERR
> +"\nVersion Control options:\n" .
> +"g  use git history      [$email_git]\n" .
> +"gf use git-fallback     [$email_git_fallback]\n" .
> +"b  use git blame        [$email_git_blame]\n" .
> +"bs use blame signatures [$email_git_blame_signatures]\n" .
> +"c# minimum commits      [$email_git_min_signatures]\n" .
> +"%# min percent          [$email_git_min_percent]\n" .
> +"d# history to use       [$$date_ref]\n" .
> +"x# max maintainers      [$email_git_max_maintainers]\n" .
> +"t  all signature types  [$email_git_all_signature_types]\n";
> +	    }
> +	    print STDERR "\nAdditional options:\n" .
> +"0  toggle all\n" .
> +"f  emails in file       [$file_emails]\n" .
> +"k  keywords in file     [$keywords]\n" .
> +"r  remove duplicates    [$email_remove_duplicates]\n" .
> +"p# pattern match depth  [$pattern_depth]\n";
> +	}
> +	print STDERR
> +"\n#(toggle), A#(author), S#(signed) *(all), ^(none), O(options), Y(approve): ";
> +
> +	my $input = <STDIN>;
> +	chomp($input);

[snip menu parsing code]

That should probably go in an extra function and be slimmed down, like
I did in a later version I sent you.



> +sub bool_invert {
> +    my ($bool_ref) = @_;
> +
> +    if ($$bool_ref) {
> +	$$bool_ref = 0;
> +    } else {
> +	$$bool_ref = 1;
> +    }
 +}

That should just be $$bool_ref = !$$bool_ref (and probably not a
function)


Regards,
Flo
