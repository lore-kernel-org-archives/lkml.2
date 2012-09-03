Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab2ICXNE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 19:13:04 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36850 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab2ICXNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 19:13:01 -0400
Message-ID: <1346713972.2312.2.camel@Cruz-PC>
Subject: Re: [PATCH 5/5] scripts/checkincludes.pl: Replace tabs with spaces
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
To: mcgrof@gmail.com
Cc: linux-kernel@vger.kernel.org
Date: Tue, 04 Sep 2012 09:12:52 +1000
In-Reply-To: <1346710853-19166-6-git-send-email-cruzjbishop@gmail.com>
References: <1346710853-19166-1-git-send-email-cruzjbishop@gmail.com>
	 <1346710853-19166-6-git-send-email-cruzjbishop@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My bad, misread the documentation files.

I'll resubmit without this

On Tue, 2012-09-04 at 08:20 +1000, Cruz Julian Bishop wrote:
> This is required by the CodingStyle kernel documentation file
> 
> Signed-off-by: Cruz Julian Bishop <cruzjbishop@gmail.com>
> ---
>  scripts/checkincludes.pl | 122 +++++++++++++++++++++++------------------------
>  1 file changed, 61 insertions(+), 61 deletions(-)
> 
> diff --git a/scripts/checkincludes.pl b/scripts/checkincludes.pl
> index bff7316..7e3df9e 100755
> --- a/scripts/checkincludes.pl
> +++ b/scripts/checkincludes.pl
> @@ -14,7 +14,7 @@
>  use strict;
>  
>  sub usage {
> -	print <<EOM;
> +        print <<EOM;
>  Usage: checkincludes.pl [OPTIONS]... FILE...
>  By default, we just warn of duplicates.
>  
> @@ -23,84 +23,84 @@ Options:
>    -q                Do not show messages for files that do not
>                      have duplicated includes
>  EOM
> -	exit 1;
> +        exit 1;
>  }
>  
>  my $remove = 0;
>  my $quiet = 0;
>  
>  if ($#ARGV < 0) {
> -	usage();
> +        usage();
>  }
>  
>  my $argc = 0;
>  
>  foreach my $arg (@ARGV) {
> -	if ($arg eq "-r") {
> -		$remove = 1;
> -	} elsif($arg eq "-q") {
> -		$quiet = 1;
> -	} else {
> -		open(my $f, '<', $arg)
> -		    or die "Cannot open $arg: $!.\n";
> -		    
> -		$argc++;
> +        if ($arg eq "-r") {
> +                $remove = 1;
> +        } elsif($arg eq "-q") {
> +                $quiet = 1;
> +        } else {
> +                open(my $f, '<', $arg)
> +                        or die "Cannot open $arg: $!.\n";
> +                    
> +                $argc++;
>  
> -		my %includedfiles = ();
> -		my @file_lines = ();
> +                my %includedfiles = ();
> +                my @file_lines = ();
>  
> -		while (<$f>) {
> -			if (m/^\s*#\s*include\s*[<"](\S*)[>"]/o) {
> -				++$includedfiles{$1};
> -			}
> -			push(@file_lines, $_);
> -		}
> +                while (<$f>) {
> +                        if (m/^\s*#\s*include\s*[<"](\S*)[>"]/o) {
> +                                ++$includedfiles{$1};
> +                        }
> +                        push(@file_lines, $_);
> +                }
>  
> -		close($f);
> +                close($f);
>  
> -		if (!$remove) {
> -			my $detected = 0;
> -			foreach my $filename (keys %includedfiles) {
> -				if ($includedfiles{$filename} > 1) {
> -					$detected++;
> -					print "$arg: $filename is included more than once.\n";
> -				}
> -			}
> -			if (!$detected && !$quiet) {
> -				print "$arg: No duplicated includes detected.\n";
> -			}
> -			next;
> -		}
> +                if (!$remove) {
> +                        my $detected = 0;
> +                        foreach my $filename (keys %includedfiles) {
> +                                if ($includedfiles{$filename} > 1) {
> +                                        $detected++;
> +                                print "$arg: $filename is included more than once.\n";
> +                                }
> +                        }
> +                        if (!$detected && !$quiet) {
> +                                print "$arg: No duplicated includes detected.\n";
> +                        }
> +                        next;
> +                }
>  
> -		open($f, '>', $arg)
> -			or die("Cannot write to $arg: $!");
> +                open($f, '>', $arg)
> +                        or die("Cannot write to $arg: $!");
>  
> -		my $dups = 0;
> -		foreach(@file_lines) {
> -			if (m/^\s*#\s*include\s*[<"](\S*)[>"]/o) {
> -				foreach my $filename (keys %includedfiles) {
> -					if ($1 eq $filename) {
> -						if ($includedfiles{$filename} > 1) {
> -							$includedfiles{$filename}--;
> -							$dups++;
> -						} else {
> -							print {$f} $_;
> -						}
> -					}
> -				}
> -			} else {
> -				print {$f} $_;
> -			}
> -		}
> -		if ($dups > 0) {
> -			print "$arg: removed $dups duplicate includes \n";
> -		} elsif (!$quiet) {
> -			print "$arg: no duplicated includes to remove \n";
> -		}
> -		close($f);
> -	}
> +                my $dups = 0;
> +                foreach(@file_lines) {
> +                        if (m/^\s*#\s*include\s*[<"](\S*)[>"]/o) {
> +                                foreach my $filename (keys %includedfiles) {
> +                                        if ($1 eq $filename) {
> +                                                if ($includedfiles{$filename} > 1) {
> +                                                        $includedfiles{$filename}--;
> +                                                        $dups++;
> +                                                } else {
> +                                                        print {$f} $_;
> +                                                }
> +                                        }
> +                                }
> +                        } else {
> +                                print {$f} $_;
> +                        }
> +                }
> +                if ($dups > 0) {
> +                        print "$arg: removed $dups duplicate includes \n";
> +                } elsif (!$quiet) {
> +                        print "$arg: no duplicated includes to remove \n";
> +                }
> +                close($f);
> +        }
>  }
>  
>  if ($argc == 0) {
> -	usage();
> +        usage();
>  }


