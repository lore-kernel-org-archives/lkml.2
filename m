Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab0LQBFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 20:05:18 -0500
Received: from iona.labri.fr ([147.210.8.143]:60001 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755768Ab0LQBFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 20:05:14 -0500
Date: Fri, 17 Dec 2010 01:31:39 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org
Subject: Hardware locality (hwloc) v1.1 released
Message-ID: <20101217003139.GF15302@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bringing even more holiday joy, the Hardware Locality (hwloc) team is pleased to announce the release of v1.1:

    http://www.open-mpi.org/projects/hwloc/ 

v1.1 is a major new release series for hwloc.  It includes many new features and changes over the v1.0.x series.  The just-released v1.0.3 is expected to be the last release of its series (see http://www.open-mpi.org/community/lists/hwloc-announce/2010/12/0010.php).

The following is a summary of the changes since the v1.0 series:

* API
  + Increase HWLOC_API_VERSION to 0x00010100 so that API changes may be
    detected at build-time.
  + Add a memory binding interface.
  + The cpuset API (hwloc/cpuset.h) is now deprecated. It is replaced by
    the bitmap API (hwloc/bitmap.h) which offers the same features with more
    generic names since it applies to CPU sets, node sets and more.
    Backward compatibility with the cpuset API and ABI is still provided but
    it will be removed in a future release.
    Old types (hwloc_cpuset_t, ...) are still available as a way to clarify
    what kind of hwloc_bitmap_t each API function manipulates.
    Upgrading to the new API only requires to replace hwloc_cpuset_ function
    calls with the corresponding hwloc_bitmap_ calls, with the following
    renaming exceptions:
    - hwloc_cpuset_cpu -> hwloc_bitmap_only
    - hwloc_cpuset_all_but_cpu -> hwloc_bitmap_allbut
    - hwloc_cpuset_from_string -> hwloc_bitmap_sscanf
  + Add an `infos' array in each object to store couples of info names and
    values. It enables generic storage of things like the old dmi board infos
    that were previously stored in machine specific attributes.
  + Add linesize cache attribute.
* Features
  + Bitmaps (and thus CPU sets and node sets) are dynamically (re-)allocated,
    the maximal number of CPUs (HWLOC_NBMAXCPUS) has been removed.
  + Improve the distance-based grouping code to better support irregular
    distance matrices.
  + Add support for device-tree to get cache information (useful on Power
    architectures).
* Helpers
  + Add NVIDIA CUDA helpers in cuda.h and cudart.h to ease interoperability
    with CUDA Runtime and Driver APIs.
  + Add Myrinet Express helper in myriexpress.h to ease interoperability.
* Tools
  + lstopo now displays physical/OS indexes by default in graphical mode
    (use -l to switch back to logical indexes). The textual output still uses
    logical by default (use -p to switch to physical indexes).
  + lstopo prefixes logical indexes with `L#' and physical indexes with `P#'.
    Physical indexes are also printed as `P#N' instead of `phys=N' within
    object attributes (in parentheses).
  + Add a legend at the bottom of the lstopo graphical output, use --no-legend
    to remove it.
  + Add hwloc-ps to list process' bindings.
  + Add --membind and --mempolicy options to hwloc-bind.
  + Improve tools command-line options by adding a generic --input option
    (and more) which replaces the old --xml, --synthetic and --fsys-root.
  + Cleanup lstopo output configuration by adding --output-format.
  + Add --intersect in hwloc-calc, and replace --objects with --largest.
  + Add the ability to work on standard input in hwloc-calc.
  + Add --from, --to and --at in hwloc-distrib.
  + Add taskset-specific functions and command-line tools options to
    manipulate CPU set strings in the format of the taskset program.
  + Install hwloc-gather-topology.sh on Linux.
